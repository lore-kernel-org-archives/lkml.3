Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbaGBQu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:50:26 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57201 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbaGBQuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:50:22 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/48] staging: rtl8188eu: Remove unused function rtw_setphy_cmd()
Date: Wed,  2 Jul 2014 22:17:07 +0530
Message-Id: <1404319664-8327-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   40 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 41 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index cc8b82c..ba325f8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -482,46 +482,6 @@ exit:
 	return res;
 }
 
-/*
-unsigned char rtw_setphy_cmd(unsigned char  *adapter)
-
-1.  be called only after rtw_update_registrypriv_dev_network(~) or mp testing program
-2.  for AdHoc/Ap mode or mp mode?
-
-*/
-u8 rtw_setphy_cmd(struct adapter *padapter, u8 modem, u8 ch)
-{
-	struct cmd_obj *ph2c;
-	struct setphy_parm *psetphypara;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-		}
-	psetphypara = kzalloc(sizeof(struct setphy_parm), GFP_KERNEL);
-
-	if (psetphypara == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, psetphypara, _SetPhy_CMD_);
-
-	RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_, ("CH =%d, modem =%d", ch, modem));
-
-	psetphypara->modem = modem;
-	psetphypara->rfchannel = ch;
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-exit:
-	return res;
-}
-
 u8 rtw_setbbreg_cmd(struct adapter *padapter, u8 offset, u8 val)
 {
 	struct cmd_obj *ph2c;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index fb999fc..9bae5541 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -733,7 +733,6 @@ u8 rtw_sitesurvey_cmd(struct adapter *padapter, struct ndis_802_11_ssid *ssid,
 u8 rtw_createbss_cmd(struct adapter *padapter);
 u8 rtw_createbss_cmd_ex(struct adapter *padapter, unsigned char *pbss,
 			unsigned int sz);
-u8 rtw_setphy_cmd(struct adapter *padapter, u8 modem, u8 ch);
 u8 rtw_setstakey_cmd(struct adapter *padapter, u8 *psta, u8 unicast_key);
 u8 rtw_clearstakey_cmd(struct adapter *padapter, u8 *psta, u8 entry,
 		       u8 enqueue);
-- 
1.7.10.4

