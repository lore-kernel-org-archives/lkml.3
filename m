Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbaGBQyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:54:43 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:64952 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaGBQyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:54:41 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 42/48] staging: rtl8188eu: Remove command _TDLS and its handler
Date: Wed,  2 Jul 2014 22:17:38 +0530
Message-Id: <1404319664-8327-42-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_TDLS command is never issued by driver and its handler is a
dummy function.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |   18 ------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h      |    2 --
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    1 -
 3 files changed, 21 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index b4dd14e..54816f7 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -5605,21 +5605,3 @@ u8 set_csa_hdl(struct adapter *padapter, unsigned char *pbuf)
 {
 	return	H2C_REJECTED;
 }
-
-/*  TDLS_WRCR		: write RCR DATA BIT */
-/*  TDLS_SD_PTI		: issue peer traffic indication */
-/*  TDLS_CS_OFF		: go back to the channel linked with AP, terminating channel switch procedure */
-/*  TDLS_INIT_CH_SEN	: init channel sensing, receive all data and mgnt frame */
-/*  TDLS_DONE_CH_SEN: channel sensing and report candidate channel */
-/*  TDLS_OFF_CH		: first time set channel to off channel */
-/*  TDLS_BASE_CH		: go back tp the channel linked with AP when set base channel as target channel */
-/*  TDLS_P_OFF_CH	: periodically go to off channel */
-/*  TDLS_P_BASE_CH	: periodically go back to base channel */
-/*  TDLS_RS_RCR		: restore RCR */
-/*  TDLS_CKALV_PH1	: check alive timer phase1 */
-/*  TDLS_CKALV_PH2	: check alive timer phase2 */
-/*  TDLS_FREE_STA	: free tdls sta */
-u8 tdls_hdl(struct adapter *padapter, unsigned char *pbuf)
-{
-	return H2C_REJECTED;
-}
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 8b0712f..1d2fc5f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -417,7 +417,6 @@ enum rtw_h2c_cmd {
 	GEN_CMD_CODE(_SetChannelPlan),
 	GEN_CMD_CODE(_LedBlink),
 	GEN_CMD_CODE(_SetChannelSwitch),
-	GEN_CMD_CODE(_TDLS),
 
 	MAX_H2CCMD
 };
@@ -442,7 +441,6 @@ static struct _cmd_callback	rtw_cmd_callback[] = {
 	{GEN_CMD_CODE(_SetChannelPlan), NULL},
 	{GEN_CMD_CODE(_LedBlink), NULL},
 	{GEN_CMD_CODE(_SetChannelSwitch), NULL},
-	{GEN_CMD_CODE(_TDLS), NULL},
 };
 #endif
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 484e874..43ed433 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -726,7 +726,6 @@ static struct cmd_hdl wlancmds[] = {
 	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelPlan_param), set_chplan_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof(struct LedBlink_param), led_blink_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelSwitch_param), set_csa_hdl)
-	GEN_MLME_EXT_HANDLER(sizeof(struct TDLSoption_param), tdls_hdl)
 };
 
 #endif
-- 
1.7.10.4

