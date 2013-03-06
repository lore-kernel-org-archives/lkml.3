Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3CFPNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:13:02 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:54082 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab3CFPM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:12:56 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] pinctrl: sunxi: Add Allwinner A13 pin functions
Date: Wed,  6 Mar 2013 16:12:45 +0100
Message-Id: <1362582765-25251-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362582765-25251-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1362582765-25251-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial driver contained only a limited set of pins functions
because we lacked of documentation on it.

Now that we have such documentation, finish to fill the array.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c |  239 +++++++++++++++++++++++++++------------
 1 file changed, 169 insertions(+), 70 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 27a75be..3e41cd1 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -988,216 +988,305 @@ static const struct sunxi_desc_pin sun5i_a13_pins[] = {
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB0,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c0")),		/* SCK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB1,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c0")),		/* SDA */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB2,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "pwm")),
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB3,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "ir0")),		/* TX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB4,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "ir0")),		/* RX */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB10,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi2")),		/* CS1 */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB15,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c1")),		/* SCK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB16,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c1")),		/* SDA */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB17,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c2")),		/* SCK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB18,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c2")),		/* SDA */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC0,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NWE */
+		SUNXI_FUNCTION(0x3, "spi0")),		/* MOSI */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC1,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NALE */
+		SUNXI_FUNCTION(0x3, "spi0")),		/* MISO */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC2,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NCLE */
+		SUNXI_FUNCTION(0x3, "spi0")),		/* CLK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC3,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NCE1 */
+		SUNXI_FUNCTION(0x3, "spi0")),		/* CS0 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC4,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0")),		/* NCE0 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC5,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0")),		/* NRE */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC6,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NRB0 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* CMD */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC7,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NRB1 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* CLK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC8,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ0 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* D0 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC9,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ1 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* D1 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC10,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ2 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* D2 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC11,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ3 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* D3 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC12,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ4 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* D4 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC13,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ5 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* D5 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC14,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ6 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* D6 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC15,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ7 */
+		SUNXI_FUNCTION(0x3, "mmc2")),		/* D7 */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC19,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* NDQS */
+		SUNXI_FUNCTION(0x4, "uart3")),		/* RTS */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD2,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D2 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD3,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D3 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD4,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D4 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD5,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D5 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD6,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D6 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD7,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D7 */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD10,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D10 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD11,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D11 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD12,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D12 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD13,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D13 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD14,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D14 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD15,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D15 */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD18,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D18 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD19,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D19 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD20,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D20 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD21,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D21 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD22,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D22 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD23,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D23 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD24,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* CLK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD25,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* DE */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD26,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* HSYNC */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD27,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* VSYNC */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE0,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* PCLK */
+		SUNXI_FUNCTION(0x4, "spi2")),		/* CS0 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE1,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* MCLK */
+		SUNXI_FUNCTION(0x4, "spi2")),		/* CLK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE2,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* HSYNC */
+		SUNXI_FUNCTION(0x4, "spi2")),		/* MOSI */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE3,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* VSYNC */
+		SUNXI_FUNCTION(0x4, "spi2")),		/* MISO */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE4,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* D0 */
+		SUNXI_FUNCTION(0x4, "mmc2")),		/* D0 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE5,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* D1 */
+		SUNXI_FUNCTION(0x4, "mmc2")),		/* D1 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE6,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* D2 */
+		SUNXI_FUNCTION(0x4, "mmc2")),		/* D2 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE7,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* D3 */
+		SUNXI_FUNCTION(0x4, "mmc2")),		/* D3 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE8,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* D4 */
+		SUNXI_FUNCTION(0x4, "mmc2")),		/* CMD */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE9,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* D5 */
+		SUNXI_FUNCTION(0x4, "mmc2")),		/* CLK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE10,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* D6 */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* TX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE11,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "csi0"),		/* D7 */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* RX */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF0,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "mmc0")),		/* D1 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF1,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "mmc0")),		/* D0 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF2,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "mmc0")),		/* CLK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF3,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "mmc0")),		/* CMD */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF4,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "mmc0")),		/* D3 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF5,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "mmc0")),		/* D2 */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG0,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
@@ -1211,24 +1300,34 @@ static const struct sunxi_desc_pin sun5i_a13_pins[] = {
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG3,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc1"),		/* CMD */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* TX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG4,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc1"),		/* CLK */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* RX */
-	/* Hole */
+/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG9,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi1"),		/* CS0 */
+		SUNXI_FUNCTION(0x3, "uart3")),		/* TX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG10,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi1"),		/* CLK */
+		SUNXI_FUNCTION(0x3, "uart3")),		/* RX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG11,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi1"),		/* MOSI */
+		SUNXI_FUNCTION(0x3, "uart3")),		/* CTS */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG12,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-		SUNXI_FUNCTION(0x1, "gpio_out")),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi1"),		/* MISO */
+		SUNXI_FUNCTION(0x3, "uart3")),		/* RTS */
 };
 
 static const struct sunxi_pinctrl_desc sun4i_a10_pinctrl_data = {
-- 
1.7.10.4

