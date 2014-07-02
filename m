Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbaGBQyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:54:51 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48814 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaGBQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:54:48 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 43/48] staging: rtl8188eu: Remove command _SetChannelSwitch and its handler
Date: Wed,  2 Jul 2014 22:17:39 +0530
Message-Id: <1404319664-8327-43-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_SetChannelSwitch command is never issued by driver and its handler is a
dummy function.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |    5 -----
 drivers/staging/rtl8188eu/include/rtw_cmd.h      |    2 --
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    1 -
 3 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 54816f7..662096d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -5600,8 +5600,3 @@ u8 led_blink_hdl(struct adapter *padapter, unsigned char *pbuf)
 		return H2C_PARAMETERS_ERROR;
 	return	H2C_SUCCESS;
 }
-
-u8 set_csa_hdl(struct adapter *padapter, unsigned char *pbuf)
-{
-	return	H2C_REJECTED;
-}
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 1d2fc5f..088db15 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -416,7 +416,6 @@ enum rtw_h2c_cmd {
 	GEN_CMD_CODE(_Set_H2C_MSG),
 	GEN_CMD_CODE(_SetChannelPlan),
 	GEN_CMD_CODE(_LedBlink),
-	GEN_CMD_CODE(_SetChannelSwitch),
 
 	MAX_H2CCMD
 };
@@ -440,7 +439,6 @@ static struct _cmd_callback	rtw_cmd_callback[] = {
 	{GEN_CMD_CODE(_Set_H2C_MSG), NULL},
 	{GEN_CMD_CODE(_SetChannelPlan), NULL},
 	{GEN_CMD_CODE(_LedBlink), NULL},
-	{GEN_CMD_CODE(_SetChannelSwitch), NULL},
 };
 #endif
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 43ed433..d5c02f2 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -725,7 +725,6 @@ static struct cmd_hdl wlancmds[] = {
 	GEN_MLME_EXT_HANDLER(0, h2c_msg_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelPlan_param), set_chplan_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof(struct LedBlink_param), led_blink_hdl)
-	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelSwitch_param), set_csa_hdl)
 };
 
 #endif
-- 
1.7.10.4

