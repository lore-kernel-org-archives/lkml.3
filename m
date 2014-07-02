Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaGBQuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:50:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46490 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbaGBQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:50:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/48] staging: rtl8188eu: Remove unused function rtw_setbasicrate_cmd()
Date: Wed,  2 Jul 2014 22:17:06 +0530
Message-Id: <1404319664-8327-10-git-send-email-navin.patidar@gmail.com>
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
index ec0990f..cc8b82c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -482,39 +482,6 @@ exit:
 	return res;
 }
 
-u8 rtw_setbasicrate_cmd(struct adapter *padapter, u8 *rateset)
-{
-	struct cmd_obj *ph2c;
-	struct setbasicrate_parm *pssetbasicratepara;
-	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-	pssetbasicratepara = kzalloc(sizeof(struct setbasicrate_parm), GFP_KERNEL);
-
-	if (pssetbasicratepara == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, pssetbasicratepara, _SetBasicRate_CMD_);
-
-	memcpy(pssetbasicratepara->basicrates, rateset, NumRates);
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-exit:
-
-
-	return res;
-}
-
-
 /*
 unsigned char rtw_setphy_cmd(unsigned char  *adapter)
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index ca17145..fb999fc 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -743,7 +743,6 @@ u8 rtw_disassoc_cmd(struct adapter *padapter, u32 deauth_timeout_ms,
 u8 rtw_setopmode_cmd(struct adapter *padapter,
 		     enum ndis_802_11_network_infra networktype);
 u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset);
-u8 rtw_setbasicrate_cmd(struct adapter *padapter, u8 *rateset);
 u8 rtw_setbbreg_cmd(struct adapter *padapter, u8 offset, u8 val);
 u8 rtw_setrfreg_cmd(struct adapter *padapter, u8 offset, u32 val);
 u8 rtw_getbbreg_cmd(struct adapter *padapter, u8 offset, u8 *pval);
-- 
1.7.10.4

