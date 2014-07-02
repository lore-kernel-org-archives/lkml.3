Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaGBQvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:51:44 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37518 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaGBQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:51:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 20/48] staging: rtl8188eu: Remove unused function rtw_setstandby_cmd()
Date: Wed,  2 Jul 2014 22:17:16 +0530
Message-Id: <1404319664-8327-20-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   34 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 35 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index bf7a81d..5fab194 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -339,40 +339,6 @@ post_process:
 	complete_and_exit(NULL, 0);
 }
 
-u8 rtw_setstandby_cmd(struct adapter *padapter, uint action)
-{
-	struct cmd_obj *ph2c;
-	struct usb_suspend_parm *psetusbsuspend;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-
-	u8 ret = _SUCCESS;
-
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		ret = _FAIL;
-		goto exit;
-	}
-
-	psetusbsuspend = kzalloc(sizeof(struct usb_suspend_parm), GFP_KERNEL);
-	if (psetusbsuspend == NULL) {
-		kfree(ph2c);
-		ret = _FAIL;
-		goto exit;
-	}
-
-	psetusbsuspend->action = action;
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, psetusbsuspend, GEN_CMD_CODE(_SetUsbSuspend));
-
-	ret = rtw_enqueue_cmd(pcmdpriv, ph2c);
-
-exit:
-
-
-	return ret;
-}
-
 /*
 rtw_sitesurvey_cmd(~)
 	### NOTE:#### (!!!!)
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 278208df..77981cd 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -718,7 +718,6 @@ Result:
 #define H2C_CMD_OVERFLOW	0x06
 #define H2C_RESERVED		0x07
 
-u8 rtw_setstandby_cmd(struct adapter *padapter, uint action);
 u8 rtw_sitesurvey_cmd(struct adapter *padapter, struct ndis_802_11_ssid *ssid,
 		      int ssid_num, struct rtw_ieee80211_channel *ch,
 		      int ch_num);
-- 
1.7.10.4

