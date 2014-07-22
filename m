Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbaGVTbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:31:00 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:57260 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbaGVTa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:30:57 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 5/7] arm: dts: omap3-gta04: Add USB host support
Date: Tue, 22 Jul 2014 21:30:18 +0200
Message-Id: <1406057420-22269-6-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406057420-22269-1-git-send-email-marek@goldelico.com>
References: <1406057420-22269-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define USB Host port mode and the PHY device.

Also provide pin multiplexer information for USB host
pins.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 45 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index 4ca1277..370c08b 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -74,9 +74,30 @@
 			};
 		};
 	};
+
+	hsusb2_phy: hsusb2_phy {
+		compatible = "usb-nop-xceiv";
+		reset-gpios = <&gpio6 14 GPIO_ACTIVE_LOW>;
+	};
 };
 
 &omap3_pmx_core {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+			&hsusb2_pins
+	>;
+
+	hsusb2_pins: pinmux_hsusb2_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x21d4, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
+			OMAP3_CORE1_IOPAD(0x21d6, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
+			OMAP3_CORE1_IOPAD(0x21d8, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
+			OMAP3_CORE1_IOPAD(0x21da, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_somi.hsusb2_data5 */
+			OMAP3_CORE1_IOPAD(0x21dc, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs0.hsusb2_data6 */
+			OMAP3_CORE1_IOPAD(0x21de, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
+		>;
+	};
+
 	uart1_pins: pinmux_uart1_pins {
 		pinctrl-single,pins = <
 			0x152 (PIN_INPUT | MUX_MODE0)		/* uart1_rx.uart1_rx */
@@ -144,6 +165,22 @@
 };
 
 &omap3_pmx_core2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+			&hsusb2_2_pins
+	>;
+
+	hsusb2_2_pins: pinmux_hsusb2_2_pins {
+		pinctrl-single,pins = <
+			OMAP3630_CORE2_IOPAD(0x25f0, PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
+			OMAP3630_CORE2_IOPAD(0x25f2, PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
+			OMAP3630_CORE2_IOPAD(0x25f4, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
+			OMAP3630_CORE2_IOPAD(0x25f6, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
+			OMAP3630_CORE2_IOPAD(0x25f8, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
+			OMAP3630_CORE2_IOPAD(0x25fa, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
+		>;
+	};
+
 	spi_gpio_pins: spi_gpio_pinmux {
 		pinctrl-single,pins = <
 			OMAP3630_CORE2_IOPAD(0x25d8, PIN_OUTPUT | MUX_MODE4) /* clk */
@@ -259,6 +296,14 @@
 	power = <50>;
 };
 
+&usbhshost {
+	port2-mode = "ehci-phy";
+};
+
+&usbhsehci {
+	phys = <0 &hsusb2_phy>;
+};
+
 &mmc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc1_pins>;
-- 
1.9.1

