Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbaGBQun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:50:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39177 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaGBQuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:50:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/48] staging: rtl8188eu: Remove unused function rtw_getbbreg_cmd()
Date: Wed,  2 Jul 2014 22:17:09 +0530
Message-Id: <1404319664-8327-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   33 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 34 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 4d78e23..96e5946 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -482,39 +482,6 @@ exit:
 	return res;
 }
 
-u8 rtw_getbbreg_cmd(struct adapter  *padapter, u8 offset, u8 *pval)
-{
-	struct cmd_obj *ph2c;
-	struct readBB_parm *prdbbparm;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-		}
-	prdbbparm = kzalloc(sizeof(struct readBB_parm), GFP_KERNEL);
-
-	if (prdbbparm == NULL) {
-		kfree(ph2c);
-		return _FAIL;
-	}
-
-	INIT_LIST_HEAD(&ph2c->list);
-	ph2c->cmdcode = GEN_CMD_CODE(_GetBBReg);
-	ph2c->parmbuf = (unsigned char *)prdbbparm;
-	ph2c->cmdsz =  sizeof(struct readBB_parm);
-	ph2c->rsp = pval;
-	ph2c->rspsz = sizeof(struct readBB_rsp);
-
-	prdbbparm->offset = offset;
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-exit:
-	return res;
-}
-
 u8 rtw_setrfreg_cmd(struct adapter  *padapter, u8 offset, u32 val)
 {
 	struct cmd_obj *ph2c;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index fe21838..f2ddb8a 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -743,7 +743,6 @@ u8 rtw_setopmode_cmd(struct adapter *padapter,
 		     enum ndis_802_11_network_infra networktype);
 u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset);
 u8 rtw_setrfreg_cmd(struct adapter *padapter, u8 offset, u32 val);
-u8 rtw_getbbreg_cmd(struct adapter *padapter, u8 offset, u8 *pval);
 u8 rtw_getrfreg_cmd(struct adapter *padapter, u8 offset, u8 *pval);
 u8 rtw_setrfintfs_cmd(struct adapter *padapter, u8 mode);
 u8 rtw_setrttbl_cmd(struct adapter *padapter,
-- 
1.7.10.4

