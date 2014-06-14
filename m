Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaFNLsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 07:48:35 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33190 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaFNLsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 07:48:32 -0400
Date: Sat, 14 Jun 2014 21:47:21 +1000
From: Vitaly Osipov <vitaly.osipov@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: rtl8712: replace kmalloc(..., sizeof(T))
Message-ID: <20140614114721.GA8454@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Andy Shevchenko on driverdev-devel, replace
v = ... sizeof(struct type_of_v) -> sizeof(*v)

Based on a cocci patch along the lines of

@@
type T;
expression E;
identifier V;
@@

T *V;
...
- V = kmalloc(sizeof(T), E);
+ V = kmalloc(sizeof(*V), E);

@@
type T;
expression E;
identifier V;
@@

T *V;
...
- V = kzalloc(sizeof(T), E);
+ V = kzalloc(sizeof(*V), E);

Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>
---
 drivers/staging/rtl8712/rtl871x_cmd.c  | 94 ++++++++++++++++------------------
 drivers/staging/rtl8712/rtl871x_io.c   |  2 +-
 drivers/staging/rtl8712/rtl871x_mlme.c |  8 +--
 drivers/staging/rtl8712/rtl871x_mp.c   |  4 +-
 4 files changed, 51 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 7a25220..1775462 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -227,10 +227,10 @@ u8 r8712_sitesurvey_cmd(struct _adapter *padapter,
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psurveyPara = kmalloc(sizeof(struct sitesurvey_parm), GFP_ATOMIC);
+	psurveyPara = kmalloc(sizeof(*psurveyPara), GFP_ATOMIC);
 	if (psurveyPara == NULL) {
 		kfree((unsigned char *) ph2c);
 		return _FAIL;
@@ -259,11 +259,10 @@ u8 r8712_setdatarate_cmd(struct _adapter *padapter, u8 *rateset)
 	struct setdatarate_parm	*pbsetdataratepara;
 	struct cmd_priv		*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pbsetdataratepara = kmalloc(sizeof(struct setdatarate_parm),
-				    GFP_ATOMIC);
+	pbsetdataratepara = kmalloc(sizeof(*pbsetdataratepara), GFP_ATOMIC);
 	if (pbsetdataratepara == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -282,11 +281,10 @@ u8 r8712_set_chplan_cmd(struct _adapter *padapter, int chplan)
 	struct SetChannelPlan_param *psetchplanpara;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetchplanpara = kmalloc(sizeof(struct SetChannelPlan_param),
-				 GFP_ATOMIC);
+	psetchplanpara = kmalloc(sizeof(*psetchplanpara), GFP_ATOMIC);
 	if (psetchplanpara == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -304,11 +302,10 @@ u8 r8712_setbasicrate_cmd(struct _adapter *padapter, u8 *rateset)
 	struct setbasicrate_parm *pssetbasicratepara;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pssetbasicratepara = kmalloc(sizeof(struct setbasicrate_parm),
-				     GFP_ATOMIC);
+	pssetbasicratepara = kmalloc(sizeof(*pssetbasicratepara), GFP_ATOMIC);
 	if (pssetbasicratepara == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -327,10 +324,10 @@ u8 r8712_setptm_cmd(struct _adapter *padapter, u8 type)
 	struct writePTM_parm	*pwriteptmparm;
 	struct cmd_priv		*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pwriteptmparm = kmalloc(sizeof(struct writePTM_parm), GFP_ATOMIC);
+	pwriteptmparm = kmalloc(sizeof(*pwriteptmparm), GFP_ATOMIC);
 	if (pwriteptmparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -347,10 +344,10 @@ u8 r8712_setfwdig_cmd(struct _adapter *padapter, u8 type)
 	struct writePTM_parm *pwriteptmparm;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pwriteptmparm = kmalloc(sizeof(struct writePTM_parm), GFP_ATOMIC);
+	pwriteptmparm = kmalloc(sizeof(*pwriteptmparm), GFP_ATOMIC);
 	if (pwriteptmparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -367,10 +364,10 @@ u8 r8712_setfwra_cmd(struct _adapter *padapter, u8 type)
 	struct writePTM_parm *pwriteptmparm;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pwriteptmparm = kmalloc(sizeof(struct writePTM_parm), GFP_ATOMIC);
+	pwriteptmparm = kmalloc(sizeof(*pwriteptmparm), GFP_ATOMIC);
 	if (pwriteptmparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -387,10 +384,10 @@ u8 r8712_setrfreg_cmd(struct _adapter  *padapter, u8 offset, u32 val)
 	struct writeRF_parm *pwriterfparm;
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pwriterfparm = kmalloc(sizeof(struct writeRF_parm), GFP_ATOMIC);
+	pwriterfparm = kmalloc(sizeof(*pwriterfparm), GFP_ATOMIC);
 	if (pwriterfparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -408,10 +405,10 @@ u8 r8712_getrfreg_cmd(struct _adapter *padapter, u8 offset, u8 *pval)
 	struct readRF_parm *prdrfparm;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	prdrfparm = kmalloc(sizeof(struct readRF_parm), GFP_ATOMIC);
+	prdrfparm = kmalloc(sizeof(*prdrfparm), GFP_ATOMIC);
 	if (prdrfparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -452,7 +449,7 @@ u8 r8712_createbss_cmd(struct _adapter *padapter)
 				 &padapter->registrypriv.dev_network;
 
 	padapter->ledpriv.LedControlHandler(padapter, LED_CTL_START_TO_LINK);
-	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	pcmd = kmalloc(sizeof(*pcmd), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return _FAIL;
 	_init_listhead(&pcmd->list);
@@ -486,7 +483,7 @@ u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 						network.InfrastructureMode;
 
 	padapter->ledpriv.LedControlHandler(padapter, LED_CTL_START_TO_LINK);
-	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	pcmd = kmalloc(sizeof(*pcmd), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return _FAIL;
 	t_len = sizeof(u32) + 6 * sizeof(unsigned char) + 2 +
@@ -624,10 +621,10 @@ u8 r8712_disassoc_cmd(struct _adapter *padapter) /* for sta_mode */
 	struct disconnect_parm *pdisconnect;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	pdisconnect_cmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	pdisconnect_cmd = kmalloc(sizeof(*pdisconnect_cmd), GFP_ATOMIC);
 	if (pdisconnect_cmd == NULL)
 		return _FAIL;
-	pdisconnect = kmalloc(sizeof(struct disconnect_parm), GFP_ATOMIC);
+	pdisconnect = kmalloc(sizeof(*pdisconnect), GFP_ATOMIC);
 	if (pdisconnect == NULL) {
 		kfree((u8 *)pdisconnect_cmd);
 		return _FAIL;
@@ -646,10 +643,10 @@ u8 r8712_setopmode_cmd(struct _adapter *padapter,
 
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetop = kmalloc(sizeof(struct setopmode_parm), GFP_ATOMIC);
+	psetop = kmalloc(sizeof(*psetop), GFP_ATOMIC);
 	if (psetop == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -670,15 +667,15 @@ u8 r8712_setstakey_cmd(struct _adapter *padapter, u8 *psta, u8 unicast_key)
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct sta_info *sta = (struct sta_info *)psta;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetstakey_para = kmalloc(sizeof(struct set_stakey_parm), GFP_ATOMIC);
+	psetstakey_para = kmalloc(sizeof(*psetstakey_para), GFP_ATOMIC);
 	if (psetstakey_para == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
 	}
-	psetstakey_rsp = kmalloc(sizeof(struct set_stakey_rsp), GFP_ATOMIC);
+	psetstakey_rsp = kmalloc(sizeof(*psetstakey_rsp), GFP_ATOMIC);
 	if (psetstakey_rsp == NULL) {
 		kfree((u8 *) ph2c);
 		kfree((u8 *) psetstakey_para);
@@ -710,10 +707,10 @@ u8 r8712_setrfintfs_cmd(struct _adapter *padapter, u8 mode)
 	struct setrfintfs_parm *psetrfintfsparm;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetrfintfsparm = kmalloc(sizeof(struct setrfintfs_parm), GFP_ATOMIC);
+	psetrfintfsparm = kmalloc(sizeof(*psetrfintfsparm), GFP_ATOMIC);
 	if (psetrfintfsparm == NULL) {
 		kfree((unsigned char *) ph2c);
 		return _FAIL;
@@ -732,10 +729,10 @@ u8 r8712_setrttbl_cmd(struct _adapter *padapter,
 	struct setratable_parm *psetrttblparm;
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetrttblparm = kmalloc(sizeof(struct setratable_parm), GFP_ATOMIC);
+	psetrttblparm = kmalloc(sizeof(*psetrttblparm), GFP_ATOMIC);
 	if (psetrttblparm == NULL) {
 		kfree((unsigned char *)ph2c);
 		return _FAIL;
@@ -753,10 +750,10 @@ u8 r8712_gettssi_cmd(struct _adapter *padapter, u8 offset, u8 *pval)
 	struct cmd_obj *ph2c;
 	struct readTSSI_parm *prdtssiparm;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	prdtssiparm = kmalloc(sizeof(struct readTSSI_parm), GFP_ATOMIC);
+	prdtssiparm = kmalloc(sizeof(*prdtssiparm), GFP_ATOMIC);
 	if (prdtssiparm == NULL) {
 		kfree((unsigned char *) ph2c);
 		return _FAIL;
@@ -779,11 +776,10 @@ u8 r8712_setMacAddr_cmd(struct _adapter *padapter, u8 *mac_addr)
 	struct cmd_obj *ph2c;
 	struct SetMacAddr_param	*psetMacAddr_para;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetMacAddr_para = kmalloc(sizeof(struct SetMacAddr_param),
-				   GFP_ATOMIC);
+	psetMacAddr_para = kmalloc(sizeof(*psetMacAddr_para), GFP_ATOMIC);
 	if (psetMacAddr_para == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
@@ -802,17 +798,15 @@ u8 r8712_setassocsta_cmd(struct _adapter *padapter, u8 *mac_addr)
 	struct set_assocsta_parm	*psetassocsta_para;
 	struct set_assocsta_rsp		*psetassocsta_rsp = NULL;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	psetassocsta_para = kmalloc(sizeof(struct set_assocsta_parm),
-				    GFP_ATOMIC);
+	psetassocsta_para = kmalloc(sizeof(*psetassocsta_para), GFP_ATOMIC);
 	if (psetassocsta_para == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
 	}
-	psetassocsta_rsp = kmalloc(sizeof(struct set_assocsta_rsp),
-				   GFP_ATOMIC);
+	psetassocsta_rsp = kmalloc(sizeof(*psetassocsta_rsp), GFP_ATOMIC);
 	if (psetassocsta_rsp == NULL) {
 		kfree((u8 *)ph2c);
 		kfree((u8 *)psetassocsta_para);
@@ -832,10 +826,10 @@ u8 r8712_addbareq_cmd(struct _adapter *padapter, u8 tid)
 	struct cmd_obj		*ph2c;
 	struct addBaReq_parm	*paddbareq_parm;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	paddbareq_parm = kmalloc(sizeof(struct addBaReq_parm), GFP_ATOMIC);
+	paddbareq_parm = kmalloc(sizeof(*paddbareq_parm), GFP_ATOMIC);
 	if (paddbareq_parm == NULL) {
 		kfree((unsigned char *)ph2c);
 		return _FAIL;
@@ -853,10 +847,10 @@ u8 r8712_wdg_wk_cmd(struct _adapter *padapter)
 	struct drvint_cmd_parm  *pdrvintcmd_param;
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	pdrvintcmd_param = kmalloc(sizeof(struct drvint_cmd_parm), GFP_ATOMIC);
+	pdrvintcmd_param = kmalloc(sizeof(*pdrvintcmd_param), GFP_ATOMIC);
 	if (pdrvintcmd_param == NULL) {
 		kfree((unsigned char *)ph2c);
 		return _FAIL;
@@ -1027,10 +1021,10 @@ u8 r8712_disconnectCtrlEx_cmd(struct _adapter *adapter, u32 enableDrvCtrl,
 	struct DisconnectCtrlEx_param *param;
 	struct cmd_priv *pcmdpriv = &adapter->cmdpriv;
 
-	ph2c = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	ph2c = kmalloc(sizeof(*ph2c), GFP_ATOMIC);
 	if (ph2c == NULL)
 		return _FAIL;
-	param = kzalloc(sizeof(struct DisconnectCtrlEx_param), GFP_ATOMIC);
+	param = kzalloc(sizeof(*param), GFP_ATOMIC);
 	if (param == NULL) {
 		kfree((unsigned char *) ph2c);
 		return _FAIL;
diff --git a/drivers/staging/rtl8712/rtl871x_io.c b/drivers/staging/rtl8712/rtl871x_io.c
index 37a841a..e881b0d 100644
--- a/drivers/staging/rtl8712/rtl871x_io.c
+++ b/drivers/staging/rtl8712/rtl871x_io.c
@@ -112,7 +112,7 @@ uint r8712_alloc_io_queue(struct _adapter *adapter)
 	struct io_queue *pio_queue;
 	struct io_req *pio_req;
 
-	pio_queue = kmalloc(sizeof(struct io_queue), GFP_ATOMIC);
+	pio_queue = kmalloc(sizeof(*pio_queue), GFP_ATOMIC);
 	if (pio_queue == NULL)
 		goto alloc_io_queue_fail;
 	_init_listhead(&pio_queue->free_ioreqs);
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 02339e1..26b8f37 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1212,11 +1212,11 @@ sint r8712_set_auth(struct _adapter *adapter,
 	struct cmd_obj *pcmd;
 	struct setauth_parm *psetauthparm;
 
-	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	pcmd = kmalloc(sizeof(*pcmd), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return _FAIL;
 
-	psetauthparm = kzalloc(sizeof(struct setauth_parm), GFP_ATOMIC);
+	psetauthparm = kzalloc(sizeof(*psetauthparm), GFP_ATOMIC);
 	if (psetauthparm == NULL) {
 		kfree((unsigned char *)pcmd);
 		return _FAIL;
@@ -1242,10 +1242,10 @@ sint r8712_set_key(struct _adapter *adapter,
 	u8 keylen;
 	sint ret = _SUCCESS;
 
-	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	pcmd = kmalloc(sizeof(*pcmd), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return _FAIL;
-	psetkeyparm = kzalloc(sizeof(struct setkey_parm), GFP_ATOMIC);
+	psetkeyparm = kzalloc(sizeof(*psetkeyparm), GFP_ATOMIC);
 	if (psetkeyparm == NULL) {
 		ret = _FAIL;
 		goto err_free_cmd;
diff --git a/drivers/staging/rtl8712/rtl871x_mp.c b/drivers/staging/rtl8712/rtl871x_mp.c
index 389062f..e48486c 100644
--- a/drivers/staging/rtl8712/rtl871x_mp.c
+++ b/drivers/staging/rtl8712/rtl871x_mp.c
@@ -281,10 +281,10 @@ void r8712_SetChannel(struct _adapter *pAdapter)
 	struct SetChannel_parm *pparm = NULL;
 	u16 code = GEN_CMD_CODE(_SetChannel);
 
-	pcmd = kmalloc(sizeof(struct cmd_obj), GFP_ATOMIC);
+	pcmd = kmalloc(sizeof(*pcmd), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return;
-	pparm = kmalloc(sizeof(struct SetChannel_parm), GFP_ATOMIC);
+	pparm = kmalloc(sizeof(*pparm), GFP_ATOMIC);
 	if (pparm == NULL) {
 		kfree(pcmd);
 		return;
-- 
1.9.1

