Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbaDTItZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:49:25 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44114 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786AbaDTItR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:49:17 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/10] staging: rtl8188eu: Remove enum LED_STRATEGY_871x .
Date: Sun, 20 Apr 2014 14:17:14 +0530
Message-Id: <1397983638-10752-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Now driver has only one type of led blinking strategy, so we don't
 need enum LED_STRATEGY_871x variable to store led blinking strategy
 type.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c |    1 -
 drivers/staging/rtl8188eu/include/rtw_led.h   |   18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
index 01eeb70..e3c86f7 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
@@ -95,7 +95,6 @@ void rtl8188eu_InitSwLeds(struct adapter *padapter)
 	struct hal_data_8188e   *haldata = GET_HAL_DATA(padapter);
 
 	pledpriv->bRegUseLed = true;
-	pledpriv->LedStrategy = SW_LED_MODE1;
 	pledpriv->LedControlHandler = LedControl8188eu;
 	haldata->bLedOpenDrain = true;
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index 0da4e27..690c82a 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -143,30 +143,12 @@ struct LED_871x {
 	(((struct LED_871x *)_LED_871x)->bLedWPSBlinkInProgress	||	\
 	((struct LED_871x *)_LED_871x)->bLedScanBlinkInProgress)
 
-/*  LED customization. */
-
-enum LED_STRATEGY_871x {
-	SW_LED_MODE0 = 0, /* SW control 1 LED via GPIO0. It is default option.*/
-	SW_LED_MODE1 = 1, /*  2 LEDs, through LED0 and LED1. For ALPHA. */
-	SW_LED_MODE2 = 2, /*  SW control 1 LED via GPIO0, customized for AzWave
-			   * 8187 minicard. */
-	SW_LED_MODE3 = 3, /*  SW control 1 LED via GPIO0, customized for Sercomm
-			   * Printer Server case. */
-	SW_LED_MODE4 = 4, /* for Edimax / Belkin */
-	SW_LED_MODE5 = 5, /* for Sercomm / Belkin */
-	SW_LED_MODE6 = 6, /* for 88CU minicard, porting from ce SW_LED_MODE7 */
-	HW_LED = 50, /*  HW control 2 LEDs, LED0 and LED1 (there are 4
-		      * different control modes, see MAC.CONFIG1 for details.)*/
-	LED_ST_NONE = 99,
-};
-
 void LedControl8188eu(struct adapter *padapter, enum LED_CTL_MODE	LedAction);
 
 struct led_priv{
 	/* add for led control */
 	struct LED_871x			SwLed0;
 	struct LED_871x			SwLed1;
-	enum LED_STRATEGY_871x	LedStrategy;
 	u8	bRegUseLed;
 	void (*LedControlHandler)(struct adapter *padapter,
 				  enum LED_CTL_MODE LedAction);
-- 
1.7.10.4

