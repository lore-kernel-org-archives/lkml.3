Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaGBQvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:51:51 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40051 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaGBQvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:51:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 21/48] staging: rtl8188eu: Remove unused function rtw_createbss_cmd_ex()
Date: Wed,  2 Jul 2014 22:17:17 +0530
Message-Id: <1404319664-8327-21-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   28 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    2 --
 2 files changed, 30 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 5fab194..ab3349f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -499,34 +499,6 @@ exit:
 	return res;
 }
 
-u8 rtw_createbss_cmd_ex(struct adapter  *padapter, unsigned char *pbss, unsigned int sz)
-{
-	struct cmd_obj *pcmd;
-	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-
-	pcmd = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (pcmd == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	INIT_LIST_HEAD(&pcmd->list);
-	pcmd->cmdcode = GEN_CMD_CODE(_CreateBss);
-	pcmd->parmbuf = pbss;
-	pcmd->cmdsz =  sz;
-	pcmd->rsp = NULL;
-	pcmd->rspsz = 0;
-
-	res = rtw_enqueue_cmd(pcmdpriv, pcmd);
-
-exit:
-
-
-	return res;
-}
-
 u8 rtw_joinbss_cmd(struct adapter  *padapter, struct wlan_network *pnetwork)
 {
 	u8	res = _SUCCESS;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 77981cd..d356cf4 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -722,8 +722,6 @@ u8 rtw_sitesurvey_cmd(struct adapter *padapter, struct ndis_802_11_ssid *ssid,
 		      int ssid_num, struct rtw_ieee80211_channel *ch,
 		      int ch_num);
 u8 rtw_createbss_cmd(struct adapter *padapter);
-u8 rtw_createbss_cmd_ex(struct adapter *padapter, unsigned char *pbss,
-			unsigned int sz);
 u8 rtw_setstakey_cmd(struct adapter *padapter, u8 *psta, u8 unicast_key);
 u8 rtw_clearstakey_cmd(struct adapter *padapter, u8 *psta, u8 entry,
 		       u8 enqueue);
-- 
1.7.10.4

