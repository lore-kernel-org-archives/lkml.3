Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaKLWoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:44:15 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:48617 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaKLWoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:44:10 -0500
From: George McCollister <george.mccollister@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Joachim Eastwood <manabian@gmail.com>, Rajendra Nayak <rnayak@ti.com>,
        Felipe Balbi <balbi@ti.com>, Carlos Garcia <carlos@cgarcia.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-omap@vger.kernel.org (open list:OMAP DEVICE TREE...)
Subject: [PATCH 2/2] ARM: dts: Add devicetree for NovaTech OrionLXm
Date: Wed, 12 Nov 2014 16:41:33 -0600
Message-Id: <1415832094-20991-2-git-send-email-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415832094-20991-1-git-send-email-george.mccollister@gmail.com>
References: <1415832094-20991-1-git-send-email-george.mccollister@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the NovaTech OrionLXm which is based on the AM335x SoC
http://www.novatechweb.com/substation-automation/orionlxm/

RAM: 512MiB
Flash: 4GB eMMC
Ethernet PHYs: 2x Micrel KSZ8041FTLI
USB ports are used internally by the expansion cards.
Internal micro SD slot is available.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 .../devicetree/bindings/arm/omap/omap.txt          |   3 +
 arch/arm/boot/dts/Makefile                         |   3 +-
 arch/arm/boot/dts/am335x-lxm.dts                   | 354 +++++++++++++++++++++
 3 files changed, 359 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/am335x-lxm.dts

diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
index ddd9bcd..4f6a82c 100644
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@ -132,6 +132,9 @@ Boards:
 - AM335X Bone : Low cost community board
   compatible = "ti,am335x-bone", "ti,am33xx", "ti,omap3"
 
+- AM335X OrionLXm : Substation Automation Platform
+  compatible = "novatech,am335x-lxm", "ti,am33xx"
+
 - OMAP5 EVM : Evaluation Module
   compatible = "ti,omap5-evm", "ti,omap5"
 
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 38c89ca..454ee6c 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -331,7 +331,8 @@ dtb-$(CONFIG_SOC_AM33XX) += am335x-base0033.dtb \
 	am335x-evm.dtb \
 	am335x-evmsk.dtb \
 	am335x-nano.dtb \
-	am335x-pepper.dtb
+	am335x-pepper.dtb \
+	am335x-lxm.dtb
 dtb-$(CONFIG_ARCH_OMAP4) += omap4-duovero-parlor.dtb \
 	omap4-panda.dtb \
 	omap4-panda-a4.dtb \
diff --git a/arch/arm/boot/dts/am335x-lxm.dts b/arch/arm/boot/dts/am335x-lxm.dts
new file mode 100644
index 0000000..0f7cbae
--- /dev/null
+++ b/arch/arm/boot/dts/am335x-lxm.dts
@@ -0,0 +1,354 @@
+/*
+ * Copyright (C) 2014 NovaTech LLC - http://www.novatechweb.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+
+#include "am33xx.dtsi"
+
+/ {
+	model = "NovaTech OrionLXm";
+	compatible = "novatech,am335x-lxm", "ti,am33xx";
+
+	cpus {
+		cpu@0 {
+			cpu0-supply = <&vdd1_reg>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x20000000>; /* 512 MB */
+	};
+
+	vbat: fixedregulator@0 {
+		compatible = "regulator-fixed";
+		regulator-name = "vbat";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		regulator-boot-on;
+	};
+
+	vmmcsd_fixed: fixedregulator@0 {
+		compatible = "regulator-fixed";
+		regulator-name = "vmmcsd_fixed";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+	};
+};
+
+&am33xx_pinmux {
+	mmc1_pins: pinmux_mmc1_pins {
+		pinctrl-single,pins = <
+			0xf0 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_dat3 */
+			0xf4 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_dat2 */
+			0xf8 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_dat1 */
+			0xfc (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_dat0 */
+			0x100 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_clk */
+			0x104 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc0_cmd */
+		>;
+	};
+
+	i2c0_pins: pinmux_i2c0_pins {
+		pinctrl-single,pins = <
+			0x188 (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c0_sda.i2c0_sda */
+			0x18c (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c0_scl.i2c0_scl */
+		>;
+	};
+
+	i2c2_pins: pinmux_i2c2_pins {
+		pinctrl-single,pins = <
+			0x178 (PIN_INPUT_PULLUP | MUX_MODE3)	/* uart1_ctsn.i2c2_sda */
+			0x17c (PIN_INPUT_PULLUP | MUX_MODE3)	/* uart1_rtsn.i2c2_scl */
+		>;
+	};
+
+	cpsw_default: cpsw_default {
+		pinctrl-single,pins = <
+			/* Slave 1 */
+			0x64 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_int */
+			0x10c (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii1_crs_dv */
+			0x110 (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii1_rxer */
+			0x114 (PIN_OUTPUT_PULLDOWN | MUX_MODE1)	/* rmii1_txen */
+			0x124 (PIN_OUTPUT_PULLDOWN | MUX_MODE1)	/* rmii1_td1 */
+			0x128 (PIN_OUTPUT_PULLDOWN | MUX_MODE1)	/* rmii1_td0 */
+			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii1_rd1 */
+			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii1_rd0 */
+			0x144 (PIN_INPUT_PULLDOWN | MUX_MODE0)	/* rmii1_refclk */
+
+			/* Slave 2 */
+			0x40 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)	/* rmii2_txen */
+			0x50 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)	/* rmii2_td1 */
+			0x54 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)	/* rmii2_td0 */
+			0x68 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* rmii2_rd1 */
+			0x6c (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* rmii2_rd0 */
+			0x70 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* rmii2_crs_dv */
+			0x74 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* rmii2_rxer */
+			0x78 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_int */
+			0x108 (PIN_INPUT_PULLDOWN | MUX_MODE1)	/* rmii2_refclk */
+		>;
+	};
+
+	cpsw_sleep: cpsw_sleep {
+		pinctrl-single,pins = <
+			/* Slave 1 reset value */
+			0x64 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_int */
+			0x10c (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_crs_dv */
+			0x110 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_rxer */
+			0x114 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_txen */
+			0x124 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_td1 */
+			0x128 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_td0 */
+			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_rd1 */
+			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_rd0 */
+			0x144 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii1_refclk */
+
+			/* Slave 2 reset value*/
+			0x40 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_txen */
+			0x50 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_td1 */
+			0x54 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_td0 */
+			0x68 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_rd1 */
+			0x6c (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_rd0 */
+			0x70 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_crs_dv */
+			0x74 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_rxer */
+			0x78 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_int */
+			0x108 (PIN_INPUT_PULLDOWN | MUX_MODE7)	/* rmii2_refclk */
+		>;
+	};
+
+	davinci_mdio_default: davinci_mdio_default {
+		pinctrl-single,pins = <
+			/* MDIO */
+			0x148 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)	/* mdio_data.mdio_data */
+			0x14c (PIN_OUTPUT_PULLUP | MUX_MODE0)			/* mdio_clk.mdio_clk */
+		>;
+	};
+
+	davinci_mdio_sleep: davinci_mdio_sleep {
+		pinctrl-single,pins = <
+			/* MDIO reset value */
+			0x148 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
+		>;
+	};
+
+	emmc_pins: pinmux_emmc_pins {
+		pinctrl-single,pins = <
+			0x80 (PIN_INPUT_PULLUP | MUX_MODE2) /* gpmc_csn1.mmc1_clk */
+			0x84 (PIN_INPUT_PULLUP | MUX_MODE2) /* gpmc_csn2.mmc1_cmd */
+			0x00 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad0.mmc1_dat0 */
+			0x04 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad1.mmc1_dat1 */
+			0x08 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad2.mmc1_dat2 */
+			0x0c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad3.mmc1_dat3 */
+			0x10 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad4.mmc1_dat4 */
+			0x14 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad5.mmc1_dat5 */
+			0x18 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad6.mmc1_dat6 */
+			0x1c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad7.mmc1_dat7 */
+		>;
+	};
+
+	uart0_pins: pinmux_uart0_pins {
+		pinctrl-single,pins = <
+			0x170 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart0_rxd.uart0_rxd */
+			0x174 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* uart0_txd.uart0_txd */
+		>;
+	};
+};
+
+
+&i2c0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c0_pins>;
+
+	status = "okay";
+	clock-frequency = <400000>;
+
+	serial_config1: serial_config1@20 {
+		compatible = "nxp,pca9539";
+		reg = <0x20>;
+	};
+
+	serial_config2: serial_config2@21 {
+		compatible = "nxp,pca9539";
+		reg = <0x21>;
+	};
+
+	tps: tps@2d {
+		reg = <0x2d>;
+	};
+};
+
+&i2c2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
+
+	status = "okay";
+	clock-frequency = <100000>;
+};
+
+/include/ "tps65910.dtsi"
+
+&tps {
+	vcc1-supply = <&vbat>;
+	vcc2-supply = <&vbat>;
+	vcc3-supply = <&vbat>;
+	vcc4-supply = <&vbat>;
+	vcc5-supply = <&vbat>;
+	vcc6-supply = <&vbat>;
+	vcc7-supply = <&vbat>;
+	vccio-supply = <&vbat>;
+
+	regulators {
+		vrtc_reg: regulator@0 {
+			regulator-always-on;
+		};
+
+		vio_reg: regulator@1 {
+			regulator-always-on;
+		};
+
+		vdd1_reg: regulator@2 {
+			regulator-name = "vdd_mpu";
+			regulator-min-microvolt = <600000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		vdd2_reg: regulator@3 {
+			regulator-always-on;
+		};
+
+		vdd3_reg: regulator@4 {
+			regulator-always-on;
+		};
+
+		vdig1_reg: regulator@5 {
+			regulator-always-on;
+		};
+
+		vdig2_reg: regulator@6 {
+			regulator-always-on;
+		};
+
+		vpll_reg: regulator@7 {
+			regulator-always-on;
+		};
+
+		vdac_reg: regulator@8 {
+			regulator-always-on;
+		};
+
+		vaux1_reg: regulator@9 {
+			regulator-always-on;
+		};
+
+		vaux2_reg: regulator@10 {
+			regulator-always-on;
+		};
+
+		vaux33_reg: regulator@11 {
+			regulator-always-on;
+		};
+
+		vmmc_reg: regulator@12 {
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+	};
+};
+
+&sham {
+	status = "okay";
+};
+
+&aes {
+	status = "okay";
+};
+
+&uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_pins>;
+
+	status = "okay";
+};
+
+&usb {
+	status = "okay";
+};
+
+&usb_ctrl_mod {
+	status = "okay";
+};
+
+&usb0_phy {
+	status = "okay";
+};
+
+&usb1_phy {
+	status = "okay";
+};
+
+&usb0 {
+	status = "okay";
+	dr_mode = "host";
+};
+
+&usb1 {
+	status = "okay";
+	dr_mode = "host";
+};
+
+&cppi41dma  {
+	status = "okay";
+};
+
+&cpsw_emac0 {
+	phy_id = <&davinci_mdio>, <5>;
+	phy-mode = "rmii";
+	dual_emac_res_vlan = <2>;
+};
+
+&cpsw_emac1 {
+	phy_id = <&davinci_mdio>, <4>;
+	phy-mode = "rmii";
+	dual_emac_res_vlan = <3>;
+};
+
+&mac {
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&cpsw_default>;
+	pinctrl-1 = <&cpsw_sleep>;
+	dual_emac = <1>;
+	status = "okay";
+};
+
+&davinci_mdio {
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&davinci_mdio_default>;
+	pinctrl-1 = <&davinci_mdio_sleep>;
+	status = "okay";
+};
+
+&mmc1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	bus-width = <4>;
+	status = "okay";
+	vmmc-supply = <&vmmc_reg>;
+	ti,vcc-aux-disable-is-sleep;
+};
+
+&mmc2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&emmc_pins>;
+	vmmc-supply = <&vmmcsd_fixed>;
+	bus-width = <8>;
+	ti,non-removable;
+	status = "okay";
+	ti,vcc-aux-disable-is-sleep;
+};
+
-- 
2.1.0

