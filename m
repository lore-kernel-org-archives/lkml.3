Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbaCERiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:38:10 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50779 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756327AbaCERf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:35:58 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 09/15] ARM: at91: sam9rlek add touchscreen support through at91_adc
Date: Wed,  5 Mar 2014 18:35:34 +0100
Message-Id: <1394040940-18246-10-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91_adc now supports reading a touchscreen for ADCs without a TSMR register.
Enable touchscreen support through at91_adc. This allows to use both a
touchscreen and the remaining ADC channel at the same time.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/board-sam9rlek.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index 604eecf6cd70..35d420247e25 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -18,6 +18,7 @@
 #include <linux/clk.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/platform_data/at91_adc.h>
 
 #include <video/atmel_lcdc.h>
 
@@ -239,6 +240,17 @@ static struct at91_tsadcc_data ek_tsadcc_data = {
 
 
 /*
+ * ADC + Touchscreen
+ */
+static struct at91_adc_data ek_adc_data = {
+	.channels_used = BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(5),
+	.use_external_triggers = true,
+	.vref = 3300,
+	.touchscreen_type = ATMEL_ADC_TOUCHSCREEN_4WIRE,
+};
+
+
+/*
  * GPIO Buttons
  */
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
@@ -312,6 +324,8 @@ static void __init ek_board_init(void)
 	at91_add_device_ac97(&ek_ac97_data);
 	/* Touch Screen Controller */
 	at91_add_device_tsadcc(&ek_tsadcc_data);
+	/* Touch Screen Controller + ADC */
+	at91_add_device_adc(&ek_adc_data);
 	/* LEDs */
 	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
 	/* Push Buttons */
-- 
1.8.3.2

