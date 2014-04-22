Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaDVNBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:01:17 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:51094 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaDVNBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:01:14 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] ARM: shmobile: armadillo800eva: Add LED support
Date: Tue, 22 Apr 2014 15:01:06 +0200
Message-Id: <1398171667-24288-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cfr. r8a7740-armadillo800eva-reference.dts

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-shmobile/board-armadillo800eva.c |   35 ++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
index 276d713f0ee9..688a69c7e5fc 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -586,6 +586,40 @@ static struct platform_device hdmi_lcdc_device = {
 	},
 };
 
+/* LEDS */
+static struct gpio_led gpio_leds[] = {
+	{
+		.name		= "led1",
+		.gpio		= 102,
+		.default_state	= LEDS_GPIO_DEFSTATE_ON,
+	}, {
+		.name		= "led2",
+		.gpio		= 111,
+		.default_state	= LEDS_GPIO_DEFSTATE_ON,
+	}, {
+		.name		= "led3",
+		.gpio		= 110,
+		.default_state	= LEDS_GPIO_DEFSTATE_ON,
+	}, {
+		.name		= "led4",
+		.gpio		= 177,
+		.default_state	= LEDS_GPIO_DEFSTATE_ON,
+	},
+};
+
+static struct gpio_led_platform_data leds_gpio_info = {
+	.leds		= gpio_leds,
+	.num_leds	= ARRAY_SIZE(gpio_leds),
+};
+
+static struct platform_device leds_gpio_device = {
+	.name   = "leds-gpio",
+	.id     = -1,
+	.dev    = {
+		.platform_data  = &leds_gpio_info,
+	},
+};
+
 /* GPIO KEY */
 #define GPIO_KEY(c, g, d, ...) \
 	{ .code = c, .gpio = g, .desc = d, .active_low = 1, __VA_ARGS__ }
@@ -1077,6 +1111,7 @@ static struct platform_device *eva_devices[] __initdata = {
 	&lcdc0_device,
 	&pwm_device,
 	&pwm_backlight_device,
+	&leds_gpio_device,
 	&gpio_keys_device,
 	&sh_eth_device,
 	&vcc_sdhi0,
-- 
1.7.9.5

