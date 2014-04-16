Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaDPGNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:13:42 -0400
Received: from smtp32.i.mail.ru ([94.100.177.92]:56337 "EHLO smtp32.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaDPGNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:13:41 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH RESEND] mfd: mc13xxx: Move definitions out of structures
Date: Wed, 16 Apr 2014 10:13:33 +0400
Message-Id: <1397628813-17012-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 include/linux/mfd/mc13xxx.h | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index a326c85..d63b1d3 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -117,10 +117,6 @@ struct mc13xxx_led_platform_data {
 
 #define MAX_LED_CONTROL_REGS	6
 
-struct mc13xxx_leds_platform_data {
-	struct mc13xxx_led_platform_data *led;
-	int num_leds;
-
 /* MC13783 LED Control 0 */
 #define MC13783_LED_C0_ENABLE		(1 << 0)
 #define MC13783_LED_C0_TRIODE_MD	(1 << 7)
@@ -169,10 +165,13 @@ struct mc13xxx_leds_platform_data {
 /* MC34708 LED Control 0 */
 #define MC34708_LED_C0_CURRENT_R(x)	(((x) & 0x3) << 9)
 #define MC34708_LED_C0_CURRENT_G(x)	(((x) & 0x3) << 21)
+
+struct mc13xxx_leds_platform_data {
+	struct mc13xxx_led_platform_data *led;
+	int num_leds;
 	u32 led_control[MAX_LED_CONTROL_REGS];
 };
 
-struct mc13xxx_buttons_platform_data {
 #define MC13783_BUTTON_DBNC_0MS		0
 #define MC13783_BUTTON_DBNC_30MS	1
 #define MC13783_BUTTON_DBNC_150MS	2
@@ -180,6 +179,8 @@ struct mc13xxx_buttons_platform_data {
 #define MC13783_BUTTON_ENABLE		(1 << 2)
 #define MC13783_BUTTON_POL_INVERT	(1 << 3)
 #define MC13783_BUTTON_RESET_EN		(1 << 4)
+
+struct mc13xxx_buttons_platform_data {
 	int b1on_flags;
 	unsigned short b1on_key;
 	int b2on_flags;
@@ -188,14 +189,14 @@ struct mc13xxx_buttons_platform_data {
 	unsigned short b3on_key;
 };
 
+#define MC13783_TS_ATO_FIRST	false
+#define MC13783_TS_ATO_EACH	true
+
 struct mc13xxx_ts_platform_data {
 	/* Delay between Touchscreen polarization and ADC Conversion.
 	 * Given in clock ticks of a 32 kHz clock which gives a granularity of
 	 * about 30.5ms */
 	u8 ato;
-
-#define MC13783_TS_ATO_FIRST false
-#define MC13783_TS_ATO_EACH  true
 	/* Use the ATO delay only for the first conversion or for each one */
 	bool atox;
 };
@@ -210,11 +211,12 @@ struct mc13xxx_codec_platform_data {
 	enum mc13783_ssi_port dac_ssi_port;
 };
 
-struct mc13xxx_platform_data {
-#define MC13XXX_USE_TOUCHSCREEN (1 << 0)
+#define MC13XXX_USE_TOUCHSCREEN	(1 << 0)
 #define MC13XXX_USE_CODEC	(1 << 1)
 #define MC13XXX_USE_ADC		(1 << 2)
 #define MC13XXX_USE_RTC		(1 << 3)
+
+struct mc13xxx_platform_data {
 	unsigned int flags;
 
 	struct mc13xxx_regulator_platform_data regulators;
-- 
1.8.3.2

