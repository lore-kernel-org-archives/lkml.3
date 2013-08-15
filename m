Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab3HOUnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:43:19 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42681 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3HOUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:43:17 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        linux@arm.linux.org.uk, tony@atomide.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH] ARM:dts: Add devicetree for gta04 board.
Date: Thu, 15 Aug 2013 22:43:05 +0200
Message-Id: <1376599385-1697-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds devicetree for gta04 (Openmoko next generation board) with necessary
support for mmc, usb, leds and button.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---

This is resurrection of patch sent in March https://lkml.org/lkml/2013/1/24/419
when I got no reply from maintainer. Patch is updated and based on linux-next (20130807)

 arch/arm/boot/dts/Makefile        |   1 +
 arch/arm/boot/dts/omap3-gta04.dts | 168 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+)
 create mode 100644 arch/arm/boot/dts/omap3-gta04.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index ada589c..f091c50 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -171,6 +171,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	omap3-beagle-xm.dtb \
 	omap3-evm.dtb \
 	omap3-tobi.dtb \
+	omap3-gta04.dtb \
 	omap3-igep0020.dtb \
 	omap3-igep0030.dtb \
 	omap4-panda.dtb \
diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
new file mode 100644
index 0000000..0987f76
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -0,0 +1,168 @@
+/*
+ * Copyright (C) 2013 Marek Belisko <marek@goldelico.com>
+ *
+ * Based on omap3-beagle-xm.dts
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+
+#include "omap36xx.dtsi"
+
+/ {
+	model = "OMAP3 GTA04";
+	compatible = "ti,omap3-gta04", "ti,omap3";
+
+	cpus {
+		cpu@0 {
+			cpu0-supply = <&vcc>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x20000000>; /* 512 MB */
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		aux-button {
+			label = "aux";
+			linux,code = <169>;
+			gpios = <&gpio1 7 GPIO_ACTIVE_LOW>;
+			gpio-key,wakeup;
+		};
+	};
+};
+
+&omap3_pmx_core {
+	uart1_pins: pinmux_uart1_pins {
+		pinctrl-single,pins = <
+			0x152 (PIN_INPUT | MUX_MODE0)		/* uart1_rx.uart1_rx */
+			0x14c (PIN_OUTPUT |MUX_MODE0)		/* uart1_tx.uart1_tx */
+		>;
+	};
+
+	uart2_pins: pinmux_uart2_pins {
+		pinctrl-single,pins = <
+			0x14a (PIN_INPUT | MUX_MODE0)		/* uart2_rx.uart2_rx */
+			0x148 (PIN_OUTPUT | MUX_MODE0)		/* uart2_tx.uart2_tx */
+		>;
+	};
+
+	uart3_pins: pinmux_uart3_pins {
+		pinctrl-single,pins = <
+			0x16e (PIN_INPUT | MUX_MODE0)		/* uart3_rx.uart3_rx */
+			0x170 (PIN_OUTPUT | MUX_MODE0)		/* uart3_tx.uart3_tx */
+		>;
+	};
+
+	mmc1_pins: pinmux_mmc1_pins {
+		pinctrl-single,pins = <
+			0x114 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_clk.sdmmc1_clk */
+			0x116 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_cmd.sdmmc1_cmd */
+			0x118 (PIN_INPUT_PULLUP | MUX_MODE0) 	/* sdmmc1_dat0.sdmmc1_dat0 */
+			0x11a (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat1.sdmmc1_dat1 */
+			0x11c (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat2.sdmmc1_dat2 */
+			0x11e (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat3.sdmmc1_dat3 */
+		>;
+	};
+};
+
+&i2c1 {
+	clock-frequency = <2600000>;
+
+	twl: twl@48 {
+		reg = <0x48>;
+		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
+		interrupt-parent = <&intc>;
+	};
+};
+
+#include "twl4030.dtsi"
+#include "twl4030_omap3.dtsi"
+
+&i2c2 {
+	clock-frequency = <400000>;
+
+	/* pressure sensor */
+	bmp085@77 {
+		compatible = "bosch,bmp085";
+		reg = <0x77>;
+	};
+
+	/* leds */
+	tca6507@45 {
+		compatible = "ti,tca6507";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x45>;
+
+		gta04_led0: red_aux@0 {
+			label = "gta04:red:aux";
+			reg = <0x0>;
+		};
+
+		gta04_led1: green_aux@1 {
+			label = "gta04:green:aux";
+			reg = <0x1>;
+		};
+
+		gta04_led3: red_power@3 {
+			label = "gta04:red:power";
+			reg = <0x3>;
+			linux,default-trigger = "default-on";
+		};
+
+		gta04_led4: green_power@4 {
+			label = "gta04:green:power";
+			reg = <0x4>;
+		};
+	};
+};
+
+&i2c3 {
+	clock-frequency = <100000>;
+};
+
+&usb_otg_hs {
+	interface-type = <0>;
+	usb-phy = <&usb2_phy>;
+	mode = <3>;
+	power = <50>;
+};
+
+&mmc1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	vmmc-supply = <&vmmc1>;
+	vmmc_aux-supply = <&vsim>;
+	bus-width = <4>;
+};
+
+&mmc2 {
+	status = "disabled";
+};
+
+&mmc3 {
+	status = "disabled";
+};
+
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_pins>;
+};
+
+&uart2 {
+       pinctrl-names = "default";
+       pinctrl-0 = <&uart2_pins>;
+};
+
+&uart3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart3_pins>;
+};
+
-- 
1.8.1.2

