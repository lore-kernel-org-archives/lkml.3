Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3AZOhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 09:37:55 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:51535 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3AZOhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 09:37:08 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: pinctrl: sunxi: Add the pinctrl pin set for Allwinner A10
Date: Sat, 26 Jan 2013 15:36:53 +0100
Message-Id: <1359211016-24097-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the Allwinner SoCs variants don't have the same set of pins to
handle, we need to declare the pin ranges available.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c |  554 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.h |   68 +++++
 2 files changed, 622 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 34b4e90..353f6a8 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -27,6 +27,554 @@
 #include "core.h"
 #include "pinctrl-sunxi.h"
 
+static const struct sunxi_desc_pin sun4i_a10_pins[] = {
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* RTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* CTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* DTR */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* DSR */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* DCD */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* RING */
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
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
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
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB20,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB21,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB22,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart0")),		/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB23,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart0")),		/* RX */
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
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC20,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC21,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC22,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC23,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC24,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
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
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
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
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
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
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart0")),		/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x4, "uart0")),		/* RX */
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
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH20,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH21,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH22,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH23,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH24,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH25,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH26,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH27,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI20,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PI21,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+};
+
 static const struct sunxi_desc_pin sun5i_a13_pins[] = {
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB0,
@@ -274,6 +822,11 @@ static const struct sunxi_desc_pin sun5i_a13_pins[] = {
 		SUNXI_FUNCTION(0x1, "gpio_out")),
 };
 
+static const struct sunxi_pinctrl_desc sun4i_a10_pinctrl_data = {
+	.pins = sun4i_a10_pins,
+	.npins = ARRAY_SIZE(sun4i_a10_pins),
+};
+
 static const struct sunxi_pinctrl_desc sun5i_a13_pinctrl_data = {
 	.pins = sun5i_a13_pins,
 	.npins = ARRAY_SIZE(sun5i_a13_pins),
@@ -720,6 +1273,7 @@ static struct gpio_chip sunxi_pinctrl_gpio_chip __devinitconst = {
 };
 
 static struct of_device_id sunxi_pinctrl_match[] = {
+	{ .compatible = "allwinner,sun4i-a10-pinctrl", .data = (void *)&sun4i_a10_pinctrl_data },
 	{ .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
 	{}
 };
diff --git a/drivers/pinctrl/pinctrl-sunxi.h b/drivers/pinctrl/pinctrl-sunxi.h
index 1ee35c0..e921621 100644
--- a/drivers/pinctrl/pinctrl-sunxi.h
+++ b/drivers/pinctrl/pinctrl-sunxi.h
@@ -22,6 +22,8 @@
 #define PE_BASE	128
 #define PF_BASE	160
 #define PG_BASE	192
+#define PH_BASE	224
+#define PI_BASE	256
 
 #define SUNXI_PINCTRL_PIN_PA0	PINCTRL_PIN(PA_BASE + 0, "PA0")
 #define SUNXI_PINCTRL_PIN_PA1	PINCTRL_PIN(PA_BASE + 1, "PA1")
@@ -254,6 +256,72 @@
 #define SUNXI_PINCTRL_PIN_PG30	PINCTRL_PIN(PG_BASE + 30, "PG30")
 #define SUNXI_PINCTRL_PIN_PG31	PINCTRL_PIN(PG_BASE + 31, "PG31")
 
+#define SUNXI_PINCTRL_PIN_PH0	PINCTRL_PIN(PH_BASE + 0, "PH0")
+#define SUNXI_PINCTRL_PIN_PH1	PINCTRL_PIN(PH_BASE + 1, "PH1")
+#define SUNXI_PINCTRL_PIN_PH2	PINCTRL_PIN(PH_BASE + 2, "PH2")
+#define SUNXI_PINCTRL_PIN_PH3	PINCTRL_PIN(PH_BASE + 3, "PH3")
+#define SUNXI_PINCTRL_PIN_PH4	PINCTRL_PIN(PH_BASE + 4, "PH4")
+#define SUNXI_PINCTRL_PIN_PH5	PINCTRL_PIN(PH_BASE + 5, "PH5")
+#define SUNXI_PINCTRL_PIN_PH6	PINCTRL_PIN(PH_BASE + 6, "PH6")
+#define SUNXI_PINCTRL_PIN_PH7	PINCTRL_PIN(PH_BASE + 7, "PH7")
+#define SUNXI_PINCTRL_PIN_PH8	PINCTRL_PIN(PH_BASE + 8, "PH8")
+#define SUNXI_PINCTRL_PIN_PH9	PINCTRL_PIN(PH_BASE + 9, "PH9")
+#define SUNXI_PINCTRL_PIN_PH10	PINCTRL_PIN(PH_BASE + 10, "PH10")
+#define SUNXI_PINCTRL_PIN_PH11	PINCTRL_PIN(PH_BASE + 11, "PH11")
+#define SUNXI_PINCTRL_PIN_PH12	PINCTRL_PIN(PH_BASE + 12, "PH12")
+#define SUNXI_PINCTRL_PIN_PH13	PINCTRL_PIN(PH_BASE + 13, "PH13")
+#define SUNXI_PINCTRL_PIN_PH14	PINCTRL_PIN(PH_BASE + 14, "PH14")
+#define SUNXI_PINCTRL_PIN_PH15	PINCTRL_PIN(PH_BASE + 15, "PH15")
+#define SUNXI_PINCTRL_PIN_PH16	PINCTRL_PIN(PH_BASE + 16, "PH16")
+#define SUNXI_PINCTRL_PIN_PH17	PINCTRL_PIN(PH_BASE + 17, "PH17")
+#define SUNXI_PINCTRL_PIN_PH18	PINCTRL_PIN(PH_BASE + 18, "PH18")
+#define SUNXI_PINCTRL_PIN_PH19	PINCTRL_PIN(PH_BASE + 19, "PH19")
+#define SUNXI_PINCTRL_PIN_PH20	PINCTRL_PIN(PH_BASE + 20, "PH20")
+#define SUNXI_PINCTRL_PIN_PH21	PINCTRL_PIN(PH_BASE + 21, "PH21")
+#define SUNXI_PINCTRL_PIN_PH22	PINCTRL_PIN(PH_BASE + 22, "PH22")
+#define SUNXI_PINCTRL_PIN_PH23	PINCTRL_PIN(PH_BASE + 23, "PH23")
+#define SUNXI_PINCTRL_PIN_PH24	PINCTRL_PIN(PH_BASE + 24, "PH24")
+#define SUNXI_PINCTRL_PIN_PH25	PINCTRL_PIN(PH_BASE + 25, "PH25")
+#define SUNXI_PINCTRL_PIN_PH26	PINCTRL_PIN(PH_BASE + 26, "PH26")
+#define SUNXI_PINCTRL_PIN_PH27	PINCTRL_PIN(PH_BASE + 27, "PH27")
+#define SUNXI_PINCTRL_PIN_PH28	PINCTRL_PIN(PH_BASE + 28, "PH28")
+#define SUNXI_PINCTRL_PIN_PH29	PINCTRL_PIN(PH_BASE + 29, "PH29")
+#define SUNXI_PINCTRL_PIN_PH30	PINCTRL_PIN(PH_BASE + 30, "PH30")
+#define SUNXI_PINCTRL_PIN_PH31	PINCTRL_PIN(PH_BASE + 31, "PH31")
+
+#define SUNXI_PINCTRL_PIN_PI0	PINCTRL_PIN(PI_BASE + 0, "PI0")
+#define SUNXI_PINCTRL_PIN_PI1	PINCTRL_PIN(PI_BASE + 1, "PI1")
+#define SUNXI_PINCTRL_PIN_PI2	PINCTRL_PIN(PI_BASE + 2, "PI2")
+#define SUNXI_PINCTRL_PIN_PI3	PINCTRL_PIN(PI_BASE + 3, "PI3")
+#define SUNXI_PINCTRL_PIN_PI4	PINCTRL_PIN(PI_BASE + 4, "PI4")
+#define SUNXI_PINCTRL_PIN_PI5	PINCTRL_PIN(PI_BASE + 5, "PI5")
+#define SUNXI_PINCTRL_PIN_PI6	PINCTRL_PIN(PI_BASE + 6, "PI6")
+#define SUNXI_PINCTRL_PIN_PI7	PINCTRL_PIN(PI_BASE + 7, "PI7")
+#define SUNXI_PINCTRL_PIN_PI8	PINCTRL_PIN(PI_BASE + 8, "PI8")
+#define SUNXI_PINCTRL_PIN_PI9	PINCTRL_PIN(PI_BASE + 9, "PI9")
+#define SUNXI_PINCTRL_PIN_PI10	PINCTRL_PIN(PI_BASE + 10, "PI10")
+#define SUNXI_PINCTRL_PIN_PI11	PINCTRL_PIN(PI_BASE + 11, "PI11")
+#define SUNXI_PINCTRL_PIN_PI12	PINCTRL_PIN(PI_BASE + 12, "PI12")
+#define SUNXI_PINCTRL_PIN_PI13	PINCTRL_PIN(PI_BASE + 13, "PI13")
+#define SUNXI_PINCTRL_PIN_PI14	PINCTRL_PIN(PI_BASE + 14, "PI14")
+#define SUNXI_PINCTRL_PIN_PI15	PINCTRL_PIN(PI_BASE + 15, "PI15")
+#define SUNXI_PINCTRL_PIN_PI16	PINCTRL_PIN(PI_BASE + 16, "PI16")
+#define SUNXI_PINCTRL_PIN_PI17	PINCTRL_PIN(PI_BASE + 17, "PI17")
+#define SUNXI_PINCTRL_PIN_PI18	PINCTRL_PIN(PI_BASE + 18, "PI18")
+#define SUNXI_PINCTRL_PIN_PI19	PINCTRL_PIN(PI_BASE + 19, "PI19")
+#define SUNXI_PINCTRL_PIN_PI20	PINCTRL_PIN(PI_BASE + 20, "PI20")
+#define SUNXI_PINCTRL_PIN_PI21	PINCTRL_PIN(PI_BASE + 21, "PI21")
+#define SUNXI_PINCTRL_PIN_PI22	PINCTRL_PIN(PI_BASE + 22, "PI22")
+#define SUNXI_PINCTRL_PIN_PI23	PINCTRL_PIN(PI_BASE + 23, "PI23")
+#define SUNXI_PINCTRL_PIN_PI24	PINCTRL_PIN(PI_BASE + 24, "PI24")
+#define SUNXI_PINCTRL_PIN_PI25	PINCTRL_PIN(PI_BASE + 25, "PI25")
+#define SUNXI_PINCTRL_PIN_PI26	PINCTRL_PIN(PI_BASE + 26, "PI26")
+#define SUNXI_PINCTRL_PIN_PI27	PINCTRL_PIN(PI_BASE + 27, "PI27")
+#define SUNXI_PINCTRL_PIN_PI28	PINCTRL_PIN(PI_BASE + 28, "PI28")
+#define SUNXI_PINCTRL_PIN_PI29	PINCTRL_PIN(PI_BASE + 29, "PI29")
+#define SUNXI_PINCTRL_PIN_PI30	PINCTRL_PIN(PI_BASE + 30, "PI30")
+#define SUNXI_PINCTRL_PIN_PI31	PINCTRL_PIN(PI_BASE + 31, "PI31")
+
 #define SUNXI_PIN_NAME_MAX_LEN	5
 
 #define BANK_MEM_SIZE		0x24
-- 
1.7.10.4

