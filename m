Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaGBQzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:55:11 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54700 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819AbaGBQzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:55:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 45/48] staging: rtl8188eu: Remove command _Set_H2C_MSG and its handler
Date: Wed,  2 Jul 2014 22:17:41 +0530
Message-Id: <1404319664-8327-45-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_Set_H2C_MSG command is never issued by driver and its handler is a
dummy function.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |    8 --------
 drivers/staging/rtl8188eu/include/rtw_cmd.h      |    2 --
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    1 -
 3 files changed, 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index e774a6f..41cfd30 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -5493,14 +5493,6 @@ _abort_event_:
 	return H2C_SUCCESS;
 }
 
-u8 h2c_msg_hdl(struct adapter *padapter, unsigned char *pbuf)
-{
-	if (!pbuf)
-		return H2C_PARAMETERS_ERROR;
-
-	return H2C_SUCCESS;
-}
-
 u8 tx_beacon_hdl(struct adapter *padapter, unsigned char *pbuf)
 {
 	if (send_beacon(padapter) == _FAIL) {
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index f5e2c45..7dfbd8b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -413,7 +413,6 @@ enum rtw_h2c_cmd {
 	GEN_CMD_CODE(_TX_Beacon),
 	GEN_CMD_CODE(_Set_MLME_EVT),
 	GEN_CMD_CODE(_Set_Drv_Extra),
-	GEN_CMD_CODE(_Set_H2C_MSG),
 	GEN_CMD_CODE(_SetChannelPlan),
 
 	MAX_H2CCMD
@@ -435,7 +434,6 @@ static struct _cmd_callback	rtw_cmd_callback[] = {
 	{GEN_CMD_CODE(_TX_Beacon), NULL},
 	{GEN_CMD_CODE(_Set_MLME_EVT), NULL},
 	{GEN_CMD_CODE(_Set_Drv_Extra), NULL},
-	{GEN_CMD_CODE(_Set_H2C_MSG), NULL},
 	{GEN_CMD_CODE(_SetChannelPlan), NULL},
 };
 #endif
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 7fa1c05..654bd36 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -722,7 +722,6 @@ static struct cmd_hdl wlancmds[] = {
 	GEN_MLME_EXT_HANDLER(sizeof(struct wlan_bssid_ex), tx_beacon_hdl)
 	GEN_MLME_EXT_HANDLER(0, mlme_evt_hdl)
 	GEN_MLME_EXT_HANDLER(0, rtw_drvextra_cmd_hdl)
-	GEN_MLME_EXT_HANDLER(0, h2c_msg_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelPlan_param), set_chplan_hdl)
 };
 
-- 
1.7.10.4

