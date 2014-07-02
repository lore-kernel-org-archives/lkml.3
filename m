Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbaGBQy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:54:59 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37922 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819AbaGBQy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:54:56 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 44/48] staging: rtl8188eu: Remove command _LedBlink and its handler
Date: Wed,  2 Jul 2014 22:17:40 +0530
Message-Id: <1404319664-8327-44-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_LedBlink command is never issued by driver and its handler is a
dummy function.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |    7 -------
 drivers/staging/rtl8188eu/include/rtw_cmd.h      |    2 --
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    1 -
 3 files changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 662096d..e774a6f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -5593,10 +5593,3 @@ u8 set_chplan_hdl(struct adapter *padapter, unsigned char *pbuf)
 
 	return	H2C_SUCCESS;
 }
-
-u8 led_blink_hdl(struct adapter *padapter, unsigned char *pbuf)
-{
-	if (!pbuf)
-		return H2C_PARAMETERS_ERROR;
-	return	H2C_SUCCESS;
-}
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 088db15..f5e2c45 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -415,7 +415,6 @@ enum rtw_h2c_cmd {
 	GEN_CMD_CODE(_Set_Drv_Extra),
 	GEN_CMD_CODE(_Set_H2C_MSG),
 	GEN_CMD_CODE(_SetChannelPlan),
-	GEN_CMD_CODE(_LedBlink),
 
 	MAX_H2CCMD
 };
@@ -438,7 +437,6 @@ static struct _cmd_callback	rtw_cmd_callback[] = {
 	{GEN_CMD_CODE(_Set_Drv_Extra), NULL},
 	{GEN_CMD_CODE(_Set_H2C_MSG), NULL},
 	{GEN_CMD_CODE(_SetChannelPlan), NULL},
-	{GEN_CMD_CODE(_LedBlink), NULL},
 };
 #endif
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index d5c02f2..7fa1c05 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -724,7 +724,6 @@ static struct cmd_hdl wlancmds[] = {
 	GEN_MLME_EXT_HANDLER(0, rtw_drvextra_cmd_hdl)
 	GEN_MLME_EXT_HANDLER(0, h2c_msg_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelPlan_param), set_chplan_hdl)
-	GEN_MLME_EXT_HANDLER(sizeof(struct LedBlink_param), led_blink_hdl)
 };
 
 #endif
-- 
1.7.10.4

