 LOCAL h, f, b
 displaystatus('Configurando la base de datos...')
 CLOSE DATABASES ALL
 IF  .NOT. DIRECTORY(SYS(2003))
    b = SYS(2003)
    MKDIR &b
 ENDIF
 b = SYS(2003)+'\'+ALLTRIM(nombdd)+'.dbc'
 CREATE DATABASE &b
 SELECT 0
 USE EXCLUSIVE configura
 PACK
 IF RECCOUNT()>1
    = MESSAGEBOX('Escoja uno de los Origenes de datos', 0)
    SET SHADOWS ON
    DEFINE POPUP gridpopup FROM MROW(), MCOL() PROMPT FIELDS configura.host MARGIN SHORTCUT
    ON SELECTION POPUP gridpopup DEACTIVATE POPUP gridpopup
    ACTIVATE POPUP gridpopup
    i = host
    ? i
    RELEASE POPUPS gridpopup
 ENDIF
 makeconn_principal(host, base)
 h = host
 USE
 makeview_empresas()
 SELECT 0
 USE empresas
 GOTO TOP
 DO WHILE  .NOT. EOF()
    displaystatus('Creando conexi�n BDD...')
    IF  .NOT. EMPTY(bdd) .AND.  .NOT. ISNULL(bdd)
       makeconn(ALLTRIM(bdd), ALLTRIM(IIF(h='localhost', h, empresas.host)))
    ENDIF
    SKIP
 ENDDO
 CLOSE DATABASES ALL
 OPEN DATA &b SHARED
 displaystatus('Base de Datos Configurada.')
ENDPROC
**
PROCEDURE MakeConn_PRINCIPAL
 PARAMETER h, b
 PRIVATE f
 f = "DSN=PostgreSQL;DATABASE="+ALLTRIM(b)+";SERVER="+ALLTRIM(h)+";PORT=5432;UID=postgres;PWD=postgres;A6=;A7=100;A8=4096;B0=254;B1=8190;BI=0;C2=dd_;;CX=1b3a3"
 CREATE CONNECTION principal  CONNSTRING &f
 DBSETPROP('PRINCIPAL', 'Connection', 'Asynchronous', .F.)
 DBSETPROP('PRINCIPAL', 'Connection', 'BatchMode', .T.)
 DBSETPROP('PRINCIPAL', 'Connection', 'Comment', '')
 DBSETPROP('PRINCIPAL', 'Connection', 'DispLogin', 1)
 DBSETPROP('PRINCIPAL', 'Connection', 'ConnectTimeOut', 15)
 DBSETPROP('PRINCIPAL', 'Connection', 'DispWarnings', .F.)
 DBSETPROP('PRINCIPAL', 'Connection', 'IdleTimeOut', 0)
 DBSETPROP('PRINCIPAL', 'Connection', 'QueryTimeOut', 0)
 DBSETPROP('PRINCIPAL', 'Connection', 'Transactions', 1)
 DBSETPROP('PRINCIPAL', 'Connection', 'Database', '')
ENDPROC
**
PROCEDURE MakeConn
 PARAMETER bd, ht
 PRIVATE b, f, h
 h = ht
 b = bd
 f = "DSN=PostgreSQL;DATABASE="+b+";SERVER="+h+";PORT=5432;UID=postgres;PWD=postgres;A6=;A7=100;A8=4096;B0=254;B1=8190;BI=-5;C2=dd_;;CX=1b103ab"
 CREATE CONNECTION &b  CONNSTRING &f
 DBSETPROP(b, 'Connection', 'Asynchronous', .F.)
 DBSETPROP(b, 'Connection', 'BatchMode', .T.)
 DBSETPROP(b, 'Connection', 'Comment', '')
 DBSETPROP(b, 'Connection', 'DispLogin', 1)
 DBSETPROP(b, 'Connection', 'ConnectTimeOut', 15)
 DBSETPROP(b, 'Connection', 'DispWarnings', .F.)
 DBSETPROP(b, 'Connection', 'IdleTimeOut', 0)
 DBSETPROP(b, 'Connection', 'QueryTimeOut', 0)
 DBSETPROP(b, 'Connection', 'Transactions', 1)
 DBSETPROP(b, 'Connection', 'Database', '')
ENDPROC
**
PROCEDURE MakeView_EMPRESAS
 CREATE SQL VIEW "EMPRESAS" REMOTE CONNECTION "PRINCIPAL" AS SELECT * FROM empresas Empresas
 DBSETPROP('EMPRESAS', 'View', 'UpdateType', 1)
 DBSETPROP('EMPRESAS', 'View', 'WhereType', 3)
 DBSETPROP('EMPRESAS', 'View', 'FetchMemo', .T.)
 DBSETPROP('EMPRESAS', 'View', 'SendUpdates', .T.)
 DBSETPROP('EMPRESAS', 'View', 'UseMemoSize', 255)
 DBSETPROP('EMPRESAS', 'View', 'FetchSize', 100)
 DBSETPROP('EMPRESAS', 'View', 'MaxRecords', -1)
 DBSETPROP('EMPRESAS', 'View', 'Tables', 'empresas')
 DBSETPROP('EMPRESAS', 'View', 'Prepared', .F.)
 DBSETPROP('EMPRESAS', 'View', 'CompareMemo', .T.)
 DBSETPROP('EMPRESAS', 'View', 'FetchAsNeeded', .F.)
 DBSETPROP('EMPRESAS', 'View', 'FetchSize', 100)
 DBSETPROP('EMPRESAS', 'View', 'Comment', "")
 DBSETPROP('EMPRESAS', 'View', 'BatchUpdateCount', 1)
 DBSETPROP('EMPRESAS', 'View', 'ShareConnection', .F.)
 DBSETPROP('EMPRESAS.idemp', 'Field', 'KeyField', .T.)
 DBSETPROP('EMPRESAS.idemp', 'Field', 'Updatable', .F.)
 DBSETPROP('EMPRESAS.idemp', 'Field', 'UpdateName', 'empresas.idemp')
 DBSETPROP('EMPRESAS.idemp', 'Field', 'DataType', "I")
 DBSETPROP('EMPRESAS.ssri', 'Field', 'KeyField', .F.)
 DBSETPROP('EMPRESAS.ssri', 'Field', 'Updatable', .T.)
 DBSETPROP('EMPRESAS.ssri', 'Field', 'UpdateName', 'empresas.ssri')
 DBSETPROP('EMPRESAS.ssri', 'Field', 'DataType', "C(60)")
 DBSETPROP('EMPRESAS.sruc', 'Field', 'KeyField', .F.)
 DBSETPROP('EMPRESAS.sruc', 'Field', 'Updatable', .T.)
 DBSETPROP('EMPRESAS.sruc', 'Field', 'UpdateName', 'empresas.sruc')
 DBSETPROP('EMPRESAS.sruc', 'Field', 'DataType', "C(13)")
 DBSETPROP('EMPRESAS.host', 'Field', 'KeyField', .F.)
 DBSETPROP('EMPRESAS.host', 'Field', 'Updatable', .T.)
 DBSETPROP('EMPRESAS.host', 'Field', 'UpdateName', 'empresas.host')
 DBSETPROP('EMPRESAS.host', 'Field', 'DataType', "C(15)")
 DBSETPROP('EMPRESAS.bdd', 'Field', 'KeyField', .F.)
 DBSETPROP('EMPRESAS.bdd', 'Field', 'Updatable', .T.)
 DBSETPROP('EMPRESAS.bdd', 'Field', 'UpdateName', 'empresas.bdd')
 DBSETPROP('EMPRESAS.bdd', 'Field', 'DataType', "C(20)")
ENDPROC
**
PROCEDURE DisplayStatus
 LPARAMETERS lcmessage
 WAIT WINDOW NOWAIT lcmessage
ENDPROC
**
