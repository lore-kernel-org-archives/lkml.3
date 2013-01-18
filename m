Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3ARVax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:30:53 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:47060 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab3ARVaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:30:52 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Stefan Roese <sr@denx.de>, Alejandro Mery <amery@geeks.cl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] ARM: pinctrl: sunxi: Add the pinctrl pin set for sun5i
Date: Fri, 18 Jan 2013 22:30:35 +0100
Message-Id: <1358544639-14761-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the Allwinner SoCs variants don't have the same set of pins to
handle, we need to declare the pin ranges available.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c |  253 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 253 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 1a81613..6f02e34 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -26,6 +26,258 @@
 #include "core.h"
 #include "pinctrl-sunxi.h"
 
+static const struct sunxi_desc_pin sun5i_a13_pins[] = {
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD20,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD21,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD22,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD23,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD24,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD25,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD26,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD27,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+};
+
+static const struct sunxi_pinctrl_desc sun5i_a13_pinctrl_data = {
+	.pins = sun5i_a13_pins,
+	.npins = ARRAY_SIZE(sun5i_a13_pins),
+};
+
 static struct sunxi_pinctrl_group *
 sunxi_pinctrl_find_group_by_name(struct sunxi_pinctrl *pctl, const char *group)
 {
@@ -371,6 +623,7 @@ static struct pinctrl_desc sunxi_pctrl_desc = {
 };
 
 static struct of_device_id sunxi_pinctrl_match[] = {
+	{ .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
 	{}
 };
 MODULE_DEVICE_TABLE(of, sunxi_pinctrl_match);
-- 
1.7.10.4

