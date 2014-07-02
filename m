Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbaGBQuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:50:50 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39841 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbaGBQur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:50:47 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/48] staging: rtl8188eu: Remove unused function rtw_[set,get]rfreg_cmd()
Date: Wed,  2 Jul 2014 22:17:10 +0530
Message-Id: <1404319664-8327-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   67 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    2 -
 2 files changed, 69 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 96e5946..c62db33 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -482,73 +482,6 @@ exit:
 	return res;
 }
 
-u8 rtw_setrfreg_cmd(struct adapter  *padapter, u8 offset, u32 val)
-{
-	struct cmd_obj *ph2c;
-	struct writeRF_parm *pwriterfparm;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-	pwriterfparm = kzalloc(sizeof(struct writeRF_parm), GFP_KERNEL);
-
-	if (pwriterfparm == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, pwriterfparm, GEN_CMD_CODE(_SetRFReg));
-
-	pwriterfparm->offset = offset;
-	pwriterfparm->value = val;
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-exit:
-	return res;
-}
-
-u8 rtw_getrfreg_cmd(struct adapter  *padapter, u8 offset, u8 *pval)
-{
-	struct cmd_obj *ph2c;
-	struct readRF_parm *prdrfparm;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	prdrfparm = kzalloc(sizeof(struct readRF_parm), GFP_KERNEL);
-	if (prdrfparm == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	INIT_LIST_HEAD(&ph2c->list);
-	ph2c->cmdcode = GEN_CMD_CODE(_GetRFReg);
-	ph2c->parmbuf = (unsigned char *)prdrfparm;
-	ph2c->cmdsz =  sizeof(struct readRF_parm);
-	ph2c->rsp = pval;
-	ph2c->rspsz = sizeof(struct readRF_rsp);
-
-	prdrfparm->offset = offset;
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-
-exit:
-
-
-	return res;
-}
-
 void rtw_getbbrfreg_cmdrsp_callback(struct adapter *padapter,  struct cmd_obj *pcmd)
 {
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index f2ddb8a..432fbd2 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -742,8 +742,6 @@ u8 rtw_disassoc_cmd(struct adapter *padapter, u32 deauth_timeout_ms,
 u8 rtw_setopmode_cmd(struct adapter *padapter,
 		     enum ndis_802_11_network_infra networktype);
 u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset);
-u8 rtw_setrfreg_cmd(struct adapter *padapter, u8 offset, u32 val);
-u8 rtw_getrfreg_cmd(struct adapter *padapter, u8 offset, u8 *pval);
 u8 rtw_setrfintfs_cmd(struct adapter *padapter, u8 mode);
 u8 rtw_setrttbl_cmd(struct adapter *padapter,
 		    struct setratable_parm *prate_table);
-- 
1.7.10.4

