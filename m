Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbaGBQud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:50:33 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33519 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbaGBQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:50:29 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/48] staging: rtl8188eu: Remove unused function rtw_setbbreg_cmd()
Date: Wed,  2 Jul 2014 22:17:08 +0530
Message-Id: <1404319664-8327-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   30 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 31 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index ba325f8..4d78e23 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -482,36 +482,6 @@ exit:
 	return res;
 }
 
-u8 rtw_setbbreg_cmd(struct adapter *padapter, u8 offset, u8 val)
-{
-	struct cmd_obj *ph2c;
-	struct writeBB_parm *pwritebbparm;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-		}
-	pwritebbparm = kzalloc(sizeof(struct writeBB_parm), GFP_KERNEL);
-
-	if (pwritebbparm == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, pwritebbparm, GEN_CMD_CODE(_SetBBReg));
-
-	pwritebbparm->offset = offset;
-	pwritebbparm->value = val;
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-exit:
-	return res;
-}
-
 u8 rtw_getbbreg_cmd(struct adapter  *padapter, u8 offset, u8 *pval)
 {
 	struct cmd_obj *ph2c;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 9bae5541..fe21838 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -742,7 +742,6 @@ u8 rtw_disassoc_cmd(struct adapter *padapter, u32 deauth_timeout_ms,
 u8 rtw_setopmode_cmd(struct adapter *padapter,
 		     enum ndis_802_11_network_infra networktype);
 u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset);
-u8 rtw_setbbreg_cmd(struct adapter *padapter, u8 offset, u8 val);
 u8 rtw_setrfreg_cmd(struct adapter *padapter, u8 offset, u32 val);
 u8 rtw_getbbreg_cmd(struct adapter *padapter, u8 offset, u8 *pval);
 u8 rtw_getrfreg_cmd(struct adapter *padapter, u8 offset, u8 *pval);
-- 
1.7.10.4

