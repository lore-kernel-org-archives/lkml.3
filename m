Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030592AbaDJM0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:26:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38595 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030532AbaDJMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:25:55 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 3/5] pinctrl: sunxi: define A31 R_PIO pin functions
Date: Thu, 10 Apr 2014 14:25:45 +0200
Message-Id: <1397132747-13917-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397132747-13917-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397132747-13917-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A31 SoC provides both PL and PM pio bank through the R_PIO block.

These pins all support gpio function and can bbe assigned to system
peripherals (like TWI, P2WI, JTAG, ...)

Add new compatible string to the DT bindings doc.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |  1 +
 drivers/pinctrl/pinctrl-sunxi-pins.h               | 74 ++++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.c                    |  1 +
 3 files changed, 76 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
index f5da7e3..d8d0656 100644
--- a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
@@ -11,6 +11,7 @@ Required properties:
   "allwinner,sun5i-a10s-pinctrl"
   "allwinner,sun5i-a13-pinctrl"
   "allwinner,sun6i-a31-pinctrl"
+  "allwinner,sun6i-a31-r-pinctrl"
   "allwinner,sun7i-a20-pinctrl"
 - reg: Should contain the register physical address and length for the
   pin controller.
diff --git a/drivers/pinctrl/pinctrl-sunxi-pins.h b/drivers/pinctrl/pinctrl-sunxi-pins.h
index 3d60669..51100ca 100644
--- a/drivers/pinctrl/pinctrl-sunxi-pins.h
+++ b/drivers/pinctrl/pinctrl-sunxi-pins.h
@@ -2820,6 +2820,74 @@ static const struct sunxi_desc_pin sun6i_a31_pins[] = {
 		  SUNXI_FUNCTION(0x2, "nand1")),	/* CE3 */
 };
 
+static const struct sunxi_desc_pin sun6i_a31_r_pins[] = {
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_twi"),		/* SCK */
+		  SUNXI_FUNCTION(0x3, "s_p2wi")),	/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_twi"),		/* SDA */
+		  SUNXI_FUNCTION(0x3, "s_p2wi")),	/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL2,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_uart")),	/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL3,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_uart")),	/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL4,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_ir")),		/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL5,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "s_jtag")),	/* MS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL6,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "s_jtag")),	/* CK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL7,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "s_jtag")),	/* DO */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL8,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "s_jtag")),	/* DI */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PM0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PM1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PM2,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "1wire")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PM3,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PM4,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PM5,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PM6,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PM7,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "rtc")),		/* CLKO */
+};
+
 static const struct sunxi_desc_pin sun7i_a20_pins[] = {
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA0,
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
@@ -3855,6 +3923,12 @@ static const struct sunxi_pinctrl_desc sun6i_a31_pinctrl_data = {
 	.npins = ARRAY_SIZE(sun6i_a31_pins),
 };
 
+static const struct sunxi_pinctrl_desc sun6i_a31_r_pinctrl_data = {
+	.pins = sun6i_a31_r_pins,
+	.npins = ARRAY_SIZE(sun6i_a31_r_pins),
+	.pin_base = PL_BASE,
+};
+
 static const struct sunxi_pinctrl_desc sun7i_a20_pinctrl_data = {
 	.pins = sun7i_a20_pins,
 	.npins = ARRAY_SIZE(sun7i_a20_pins),
diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 64bcc68..ee62027 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -677,6 +677,7 @@ static struct of_device_id sunxi_pinctrl_match[] = {
 	{ .compatible = "allwinner,sun5i-a10s-pinctrl", .data = (void *)&sun5i_a10s_pinctrl_data },
 	{ .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
 	{ .compatible = "allwinner,sun6i-a31-pinctrl", .data = (void *)&sun6i_a31_pinctrl_data },
+	{ .compatible = "allwinner,sun6i-a31-r-pinctrl", .data = (void *)&sun6i_a31_r_pinctrl_data },
 	{ .compatible = "allwinner,sun7i-a20-pinctrl", .data = (void *)&sun7i_a20_pinctrl_data },
 	{}
 };
-- 
1.8.3.2

