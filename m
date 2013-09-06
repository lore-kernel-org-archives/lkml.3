Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860Ab3IFGdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:33:46 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34985 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3IFGdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:33:44 -0400
From: Koen Kooi <koen@dominion.thruhere.net>
To: linux-omap@vger.kernel.org
Cc: bcousson@baylibre.com, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCH] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
Date: Fri,  6 Sep 2013 08:33:24 +0200
Message-Id: <1378449204-8601-1-git-send-email-koen@dominion.thruhere.net>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
so create a common dtsi both can use. MMC support for AM335x still isn't in, so
only the LDO change has been added.

Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
---
 .../{am335x-bone.dts => am335x-bone-common.dtsi}   |   3 -
 arch/arm/boot/dts/am335x-bone.dts                  | 256 +--------------------
 arch/arm/boot/dts/am335x-boneblack.dts             |  18 ++
 3 files changed, 19 insertions(+), 258 deletions(-)
 copy arch/arm/boot/dts/{am335x-bone.dts => am335x-bone-common.dtsi} (99%)
 create mode 100644 arch/arm/boot/dts/am335x-boneblack.dts

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone-common.dtsi
similarity index 99%
copy from arch/arm/boot/dts/am335x-bone.dts
copy to arch/arm/boot/dts/am335x-bone-common.dtsi
index d318987..2f66ded 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -5,9 +5,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-/dts-v1/;
-
-#include "am33xx.dtsi"
 
 / {
 	model = "TI AM335x BeagleBone";
diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index d318987..7993c48 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -8,258 +8,4 @@
 /dts-v1/;
 
 #include "am33xx.dtsi"
-
-/ {
-	model = "TI AM335x BeagleBone";
-	compatible = "ti,am335x-bone", "ti,am33xx";
-
-	cpus {
-		cpu@0 {
-			cpu0-supply = <&dcdc2_reg>;
-		};
-	};
-
-	memory {
-		device_type = "memory";
-		reg = <0x80000000 0x10000000>; /* 256 MB */
-	};
-
-	am33xx_pinmux: pinmux@44e10800 {
-		pinctrl-names = "default";
-		pinctrl-0 = <&clkout2_pin>;
-
-		user_leds_s0: user_leds_s0 {
-			pinctrl-single,pins = <
-				0x54 (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a5.gpio1_21 */
-				0x58 (PIN_OUTPUT_PULLUP | MUX_MODE7)	/* gpmc_a6.gpio1_22 */
-				0x5c (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a7.gpio1_23 */
-				0x60 (PIN_OUTPUT_PULLUP | MUX_MODE7)	/* gpmc_a8.gpio1_24 */
-			>;
-		};
-
-		i2c0_pins: pinmux_i2c0_pins {
-			pinctrl-single,pins = <
-				0x188 (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c0_sda.i2c0_sda */
-				0x18c (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c0_scl.i2c0_scl */
-			>;
-		};
-
-		uart0_pins: pinmux_uart0_pins {
-			pinctrl-single,pins = <
-				0x170 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart0_rxd.uart0_rxd */
-				0x174 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* uart0_txd.uart0_txd */
-			>;
-		};
-
-		clkout2_pin: pinmux_clkout2_pin {
-			pinctrl-single,pins = <
-				0x1b4 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)	/* xdma_event_intr1.clkout2 */
-			>;
-		};
-
-		cpsw_default: cpsw_default {
-			pinctrl-single,pins = <
-				/* Slave 1 */
-				0x110 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxerr.mii1_rxerr */
-				0x114 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txen.mii1_txen */
-				0x118 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxdv.mii1_rxdv */
-				0x11c (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txd3.mii1_txd3 */
-				0x120 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txd2.mii1_txd2 */
-				0x124 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txd1.mii1_txd1 */
-				0x128 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mii1_txd0.mii1_txd0 */
-				0x12c (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_txclk.mii1_txclk */
-				0x130 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxclk.mii1_rxclk */
-				0x134 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxd3.mii1_rxd3 */
-				0x138 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxd2.mii1_rxd2 */
-				0x13c (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxd1.mii1_rxd1 */
-				0x140 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mii1_rxd0.mii1_rxd0 */
-			>;
-		};
-
-		cpsw_sleep: cpsw_sleep {
-			pinctrl-single,pins = <
-				/* Slave 1 reset value */
-				0x110 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x114 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x118 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x11c (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x120 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x124 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x128 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x12c (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x130 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x134 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x138 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x13c (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x140 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-			>;
-		};
-
-		davinci_mdio_default: davinci_mdio_default {
-			pinctrl-single,pins = <
-				/* MDIO */
-				0x148 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)	/* mdio_data.mdio_data */
-				0x14c (PIN_OUTPUT_PULLUP | MUX_MODE0)			/* mdio_clk.mdio_clk */
-			>;
-		};
-
-		davinci_mdio_sleep: davinci_mdio_sleep {
-			pinctrl-single,pins = <
-				/* MDIO reset value */
-				0x148 (PIN_INPUT_PULLDOWN | MUX_MODE7)
-				0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
-			>;
-		};
-	};
-
-	ocp {
-		uart0: serial@44e09000 {
-			pinctrl-names = "default";
-			pinctrl-0 = <&uart0_pins>;
-
-			status = "okay";
-		};
-
-		musb: usb@47400000 {
-			status = "okay";
-
-			control@44e10000 {
-				status = "okay";
-			};
-
-			usb-phy@47401300 {
-				status = "okay";
-			};
-
-			usb-phy@47401b00 {
-				status = "okay";
-			};
-
-			usb@47401000 {
-				status = "okay";
-			};
-
-			usb@47401800 {
-				status = "okay";
-				dr_mode = "host";
-			};
-
-			dma-controller@07402000  {
-				status = "okay";
-			};
-		};
-
-		i2c0: i2c@44e0b000 {
-			pinctrl-names = "default";
-			pinctrl-0 = <&i2c0_pins>;
-
-			status = "okay";
-			clock-frequency = <400000>;
-
-			tps: tps@24 {
-				reg = <0x24>;
-			};
-
-		};
-	};
-
-	leds {
-		pinctrl-names = "default";
-		pinctrl-0 = <&user_leds_s0>;
-
-		compatible = "gpio-leds";
-
-		led@2 {
-			label = "beaglebone:green:heartbeat";
-			gpios = <&gpio1 21 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "heartbeat";
-			default-state = "off";
-		};
-
-		led@3 {
-			label = "beaglebone:green:mmc0";
-			gpios = <&gpio1 22 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "mmc0";
-			default-state = "off";
-		};
-
-		led@4 {
-			label = "beaglebone:green:usr2";
-			gpios = <&gpio1 23 GPIO_ACTIVE_HIGH>;
-			default-state = "off";
-		};
-
-		led@5 {
-			label = "beaglebone:green:usr3";
-			gpios = <&gpio1 24 GPIO_ACTIVE_HIGH>;
-			default-state = "off";
-		};
-	};
-};
-
-/include/ "tps65217.dtsi"
-
-&tps {
-	regulators {
-		dcdc1_reg: regulator@0 {
-			regulator-always-on;
-		};
-
-		dcdc2_reg: regulator@1 {
-			/* VDD_MPU voltage limits 0.95V - 1.26V with +/-4% tolerance */
-			regulator-name = "vdd_mpu";
-			regulator-min-microvolt = <925000>;
-			regulator-max-microvolt = <1325000>;
-			regulator-boot-on;
-			regulator-always-on;
-		};
-
-		dcdc3_reg: regulator@2 {
-			/* VDD_CORE voltage limits 0.95V - 1.1V with +/-4% tolerance */
-			regulator-name = "vdd_core";
-			regulator-min-microvolt = <925000>;
-			regulator-max-microvolt = <1150000>;
-			regulator-boot-on;
-			regulator-always-on;
-		};
-
-		ldo1_reg: regulator@3 {
-			regulator-always-on;
-		};
-
-		ldo2_reg: regulator@4 {
-			regulator-always-on;
-		};
-
-		ldo3_reg: regulator@5 {
-			regulator-always-on;
-		};
-
-		ldo4_reg: regulator@6 {
-			regulator-always-on;
-		};
-	};
-};
-
-&cpsw_emac0 {
-	phy_id = <&davinci_mdio>, <0>;
-	phy-mode = "mii";
-};
-
-&cpsw_emac1 {
-	phy_id = <&davinci_mdio>, <1>;
-	phy-mode = "mii";
-};
-
-&mac {
-	pinctrl-names = "default", "sleep";
-	pinctrl-0 = <&cpsw_default>;
-	pinctrl-1 = <&cpsw_sleep>;
-
-};
-
-&davinci_mdio {
-	pinctrl-names = "default", "sleep";
-	pinctrl-0 = <&davinci_mdio_default>;
-	pinctrl-1 = <&davinci_mdio_sleep>;
-};
+#include "am335x-bone-common.dtsi"
diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
new file mode 100644
index 0000000..68d12aa
--- /dev/null
+++ b/arch/arm/boot/dts/am335x-boneblack.dts
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+
+#include "am33xx.dtsi"
+#include "am335x-bone-common.dtsi"
+
+&ldo3_reg {
+	regulator-min-microvolt = <1800000>;
+	regulator-max-microvolt = <1800000>;
+	regulator-always-on;
+};
+
-- 
1.8.2.1

