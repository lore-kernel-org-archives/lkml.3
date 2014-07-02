Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbaGBRCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:02:51 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63897 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaGBQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:49:56 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/48] staging: rtl8188eu: Remove unused function rtw_getrttbl_cmd()
Date: Wed,  2 Jul 2014 22:17:04 +0530
Message-Id: <1404319664-8327-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   34 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    8 -------
 2 files changed, 42 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index a2b355c..294c9e2 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -1122,40 +1122,6 @@ exit:
 	return res;
 }
 
-u8 rtw_getrttbl_cmd(struct adapter  *padapter, struct getratable_rsp *pval)
-{
-	struct cmd_obj *ph2c;
-	struct getratable_parm *pgetrttblparm;
-	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-	pgetrttblparm = kzalloc(sizeof(struct getratable_parm), GFP_KERNEL);
-
-	if (pgetrttblparm == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	INIT_LIST_HEAD(&ph2c->list);
-	ph2c->cmdcode = GEN_CMD_CODE(_GetRaTable);
-	ph2c->parmbuf = (unsigned char *)pgetrttblparm;
-	ph2c->cmdsz =  sizeof(struct getratable_parm);
-	ph2c->rsp = (u8 *)pval;
-	ph2c->rspsz = sizeof(struct getratable_rsp);
-
-	pgetrttblparm->rsvd = 0x0;
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-exit:
-	return res;
-}
-
 u8 rtw_setassocsta_cmd(struct adapter  *padapter, u8 *mac_addr)
 {
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 049e112..bb1f8f0 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -601,13 +601,6 @@ struct getratable_parm {
 	uint rsvd;
 };
 
-struct getratable_rsp {
-	u8 ss_ForceUp[NumRates];
-	u8 ss_ULevel[NumRates];
-	u8 ss_DLevel[NumRates];
-	u8 count_judge[NumRates];
-};
-
 /* to get TX,RX retry count */
 
 struct gettxretrycnt_parm {
@@ -758,7 +751,6 @@ u8 rtw_getrfreg_cmd(struct adapter *padapter, u8 offset, u8 *pval);
 u8 rtw_setrfintfs_cmd(struct adapter *padapter, u8 mode);
 u8 rtw_setrttbl_cmd(struct adapter *padapter,
 		    struct setratable_parm *prate_table);
-u8 rtw_getrttbl_cmd(struct adapter *padapter, struct getratable_rsp *pval);
 
 u8 rtw_gettssi_cmd(struct adapter *padapter, u8 offset, u8 *pval);
 u8 rtw_setfwdig_cmd(struct adapter *padapter, u8 type);
-- 
1.7.10.4

