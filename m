Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbaKFXZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:25:15 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61377 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaKFXZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:25:06 -0500
From: Krzysztof Konopko <kris@konagma.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: navin.patidar@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kris@konagma.com
Subject: [PATCH 2/3] rtl8188eu: Fix a typo in rtw_led.*
Date: Fri,  7 Nov 2014 00:24:27 +0100
Message-Id: <1415316268-10278-2-git-send-email-kris@konagma.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415316268-10278-1-git-send-email-kris@konagma.com>
References: <1415316268-10278-1-git-send-email-kris@konagma.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A rather obvious typo in one of the identifier has been found.  This patch
fixes the typo and ensures any lines changed do not exceed 80 characters
as indicated by scripts/checkpatch.pl

Signed-off-by: Krzysztof Konopko <kris@konagma.com>
---
 drivers/staging/rtl8188eu/core/rtw_led.c    | 6 ++++--
 drivers/staging/rtl8188eu/include/rtw_led.h | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_led.c b/drivers/staging/rtl8188eu/core/rtw_led.c
index c6e8379..1b8264b 100644
--- a/drivers/staging/rtl8188eu/core/rtw_led.c
+++ b/drivers/staging/rtl8188eu/core/rtw_led.c
@@ -224,7 +224,8 @@ static void SwLedBlink1(struct LED_871x *pLed)
 			pLed->bLedWPSBlinkInProgress = false;
 		} else {
 			pLed->BlinkingLedState = RTW_LED_OFF;
-			_set_timer(&(pLed->BlinkTimer), LED_BLINK_WPS_SUCESS_INTERVAL_ALPHA);
+			_set_timer(&(pLed->BlinkTimer),
+				   LED_BLINK_WPS_SUCCESS_INTERVAL_ALPHA);
 		}
 		break;
 	default:
@@ -388,7 +389,8 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 		pLed->CurrLedState = LED_BLINK_WPS_STOP;
 		if (pLed->bLedOn) {
 			pLed->BlinkingLedState = RTW_LED_OFF;
-			_set_timer(&(pLed->BlinkTimer), LED_BLINK_WPS_SUCESS_INTERVAL_ALPHA);
+			_set_timer(&(pLed->BlinkTimer),
+				   LED_BLINK_WPS_SUCCESS_INTERVAL_ALPHA);
 		} else {
 			pLed->BlinkingLedState = RTW_LED_ON;
 			_set_timer(&(pLed->BlinkTimer), 0);
diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index c49a9a1..23f0cfe 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -23,7 +23,7 @@
 #define LED_BLINK_LINK_INTERVAL_ALPHA		500	/* 500 */
 #define LED_BLINK_SCAN_INTERVAL_ALPHA		180	/* 150 */
 #define LED_BLINK_FASTER_INTERVAL_ALPHA		50
-#define LED_BLINK_WPS_SUCESS_INTERVAL_ALPHA	5000
+#define LED_BLINK_WPS_SUCCESS_INTERVAL_ALPHA	5000
 
 enum LED_CTL_MODE {
 	LED_CTL_POWER_ON,
-- 
2.1.1

