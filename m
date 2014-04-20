Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaDTIsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:48:21 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48706 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaDTIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:48:15 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/10] staging: rtl8188eu: Remove rtw_led_blink_cmd() function.
Date: Sun, 20 Apr 2014 14:17:10 +0530
Message-Id: <1397983638-10752-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_led_blink_cmd() isn't being used by driver.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   35 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 36 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index c2fb050..1e0b8b4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -1431,41 +1431,6 @@ exit:
 	return res;
 }
 
-u8 rtw_led_blink_cmd(struct adapter *padapter, struct LED_871x *pLed)
-{
-	struct	cmd_obj *pcmdobj;
-	struct	LedBlink_param *ledBlink_param;
-	struct	cmd_priv   *pcmdpriv = &padapter->cmdpriv;
-
-	u8	res = _SUCCESS;
-
-
-	RT_TRACE(_module_rtl871x_cmd_c_, _drv_notice_, ("+rtw_led_blink_cmd\n"));
-
-	pcmdobj = (struct cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
-	if (pcmdobj == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	ledBlink_param = (struct	LedBlink_param *)rtw_zmalloc(sizeof(struct	LedBlink_param));
-	if (ledBlink_param == NULL) {
-		kfree(pcmdobj);
-		res = _FAIL;
-		goto exit;
-	}
-
-	ledBlink_param->pLed = pLed;
-
-	init_h2fwcmd_w_parm_no_rsp(pcmdobj, ledBlink_param, GEN_CMD_CODE(_LedBlink));
-	res = rtw_enqueue_cmd(pcmdpriv, pcmdobj);
-
-exit:
-
-
-	return res;
-}
-
 u8 rtw_set_csa_cmd(struct adapter *padapter, u8 new_ch_no)
 {
 	struct	cmd_obj *pcmdobj;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 3d34702..66467f7 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -807,7 +807,6 @@ u8 rtw_chk_hi_queue_cmd(struct adapter *padapter);
 u8 rtw_set_ch_cmd(struct adapter *padapter, u8 ch, u8 bw, u8 ch_offset,
 		  u8 enqueue);
 u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue);
-u8 rtw_led_blink_cmd(struct adapter *padapter, struct LED_871x *pLed);
 u8 rtw_set_csa_cmd(struct adapter *padapter, u8 new_ch_no);
 u8 rtw_tdls_cmd(struct adapter *padapter, u8 *addr, u8 option);
 
-- 
1.7.10.4

