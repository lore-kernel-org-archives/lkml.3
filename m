Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbaGBQyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:54:14 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35417 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbaGBQyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:54:09 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 38/48] staging: rtl8188eu: Remove function rtw_getbbrfreg_cmdrsp_callback()
Date: Wed,  2 Jul 2014 22:17:34 +0530
Message-Id: <1404319664-8327-38-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_getbbrfreg_cmdrsp_callback() is a callback for _Read_BBREG and _Read_RFREG
commands but these commands are never issued by driver.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |    8 --------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    5 ++---
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 817f459..3e82ba4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -375,14 +375,6 @@ exit:
 	return res;
 }
 
-void rtw_getbbrfreg_cmdrsp_callback(struct adapter *padapter,  struct cmd_obj *pcmd)
-{
-
-	kfree(pcmd->parmbuf);
-	kfree(pcmd);
-
-}
-
 void rtw_readtssi_cmdrsp_callback(struct adapter *padapter,  struct cmd_obj *pcmd)
 {
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 08b371d..3f3f257 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -491,7 +491,6 @@ void rtw_survey_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd);
 void rtw_disassoc_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd);
 void rtw_joinbss_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd);
 void rtw_createbss_cmd_callback(struct adapter *adapt, struct cmd_obj *pcmd);
-void rtw_getbbrfreg_cmdrsp_callback(struct adapter *adapt, struct cmd_obj *cmd);
 void rtw_readtssi_cmdrsp_callback(struct adapter *adapt, struct cmd_obj *cmd);
 
 void rtw_setstaKey_cmdrsp_callback(struct adapter *adapt, struct cmd_obj *cmd);
@@ -583,9 +582,9 @@ enum rtw_h2c_cmd {
 static struct _cmd_callback	rtw_cmd_callback[] = {
 	{GEN_CMD_CODE(_Read_MACREG), NULL}, /*0*/
 	{GEN_CMD_CODE(_Write_MACREG), NULL},
-	{GEN_CMD_CODE(_Read_BBREG), &rtw_getbbrfreg_cmdrsp_callback},
+	{GEN_CMD_CODE(_Read_BBREG), NULL},
 	{GEN_CMD_CODE(_Write_BBREG), NULL},
-	{GEN_CMD_CODE(_Read_RFREG), &rtw_getbbrfreg_cmdrsp_callback},
+	{GEN_CMD_CODE(_Read_RFREG), NULL},
 	{GEN_CMD_CODE(_Write_RFREG), NULL}, /*5*/
 	{GEN_CMD_CODE(_Read_EEPROM), NULL},
 	{GEN_CMD_CODE(_Write_EEPROM), NULL},
-- 
1.7.10.4

