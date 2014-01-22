Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaAVLwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:52:42 -0500
Received: from eumx.net ([91.82.101.43]:60269 "EHLO owm.eumx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbaAVLwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:52:39 -0500
X-Greylist: delayed 2703 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2014 06:52:38 EST
From: Jack Mitchell <ml@embed.me.uk>
To: bcousson@baylibre.com, tony@atomide.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jack Mitchell <jack@embed.me.uk>, Matt Porter <mporter@linaro.org>
Subject: [PATCH] ARM: dts: add BeagleBone Audio Cape (Rev A) dtsi
Date: Wed, 22 Jan 2014 11:06:25 +0000
Message-Id: <1390388785-19605-1-git-send-email-ml@embed.me.uk>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Mitchell <jack@embed.me.uk>

Devicetree include file for setting up the am335x mcasp bus, i2c-2
bus, and audio codec required for a functioning BeagleBone Audio Cape.

Signed-off-by: Jack Mitchell <jack@embed.me.uk>
Signed-off-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi | 124 +++++++++++++++++++++
 arch/arm/boot/dts/am335x-bone-common.dtsi          |  14 +++
 2 files changed, 138 insertions(+)
 create mode 100644 arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi

diff --git a/arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi b/arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi
new file mode 100644
index 0000000..b8ec3dc
--- /dev/null
+++ b/arch/arm/boot/dts/am335x-bone-audio-cape-reva.dtsi
@@ -0,0 +1,124 @@
+/*
+ * Copyright (C) 2014 Jack Mitchell <jack@embed.me.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * In order to enable the BeagleBone Audio Cape this dtsi must be
+ * incuded in the top level dts. On BeagleBone Black hardware the
+ * status of the HDMI dts node must also be set to "disabled".
+ *
+ * --- a/arch/arm/boot/dts/am335x-bone.dts
+ * +++ b/arch/arm/boot/dts/am335x-bone.dts
+ * @@ -9,6 +9,7 @@
+ *
+ *  #include "am33xx.dtsi"
+ *  #include "am335x-bone-common.dtsi"
+ * +#include "am335x-bone-audio-cape-reva.dtsi"
+ *
+ *  &ldo3_reg {
+ *  	regulator-min-microvolt = <1800000>;
+ *
+ * On BeagleBone Black hardware the status of the HDMI dts node must
+ * also be set to "disabled"
+ *
+ * --- a/arch/arm/boot/dts/am335x-boneblack.dts
+ * +++ b/arch/arm/boot/dts/am335x-boneblack.dts
+ * @@ -73,6 +74,6 @@
+ *  		pinctrl-names = "default", "off";
+ *  		pinctrl-0 = <&nxp_hdmi_bonelt_pins>;
+ *  		pinctrl-1 = <&nxp_hdmi_bonelt_off_pins>;
+ * -		status = "okay";
+ * +		status = "disabled";
+ *  	};
+ *  };
+ */
+
+/ {
+	sound {
+		compatible = "ti,da830-evm-audio";
+		ti,model = "AM335x BeagleBone Audio Cape Rev. A";
+		ti,audio-codec = <&tlv320aic3106>;
+		ti,mcasp-controller = <&mcasp0>;
+		ti,codec-clock-rate = <12000000>;
+		ti,audio-routing =
+			"Headphone Jack",       "HPLOUT",
+			"Headphone Jack",       "HPROUT",
+			"LINE1L",               "Line In",
+			"LINE1R",               "Line In";
+	};
+
+	audio-cape-gpio-leds {
+		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&bone_audio_cape_led_pins>;
+
+		audio-led0 {
+			label = "audio:green:usr0";
+			gpios = <&gpio1 18 GPIO_ACTIVE_HIGH>;
+			linux,default-trigger = "heartbeat";
+			default-state = "off";
+		};
+
+		audio-led1 {
+			label = "audio:green:usr1";
+			gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>;
+			linux,default-trigger = "mmc0";
+			default-state = "off";
+		};
+	};
+};
+
+&am33xx_pinmux {
+	bone_audio_cape_led_pins: pinmux_bone_audio_cape_led_pins {
+		pinctrl-single,pins = <
+			0x48 (PIN_OUTPUT_PULLDOWN | MUX_MODE7) /* gpmc_a2.gpio1_18 */
+			0x4c (PIN_OUTPUT_PULLDOWN | MUX_MODE7) /* gpmc_a3.gpio1_19 */
+		>;
+	};
+
+	bone_audio_cape_pins: bone_audio_cape_pins {
+		pinctrl-single,pins = <
+			0x190 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mcasp0_aclkx.mcasp0_aclkx */
+			0x194 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mcasp0_fsx.mcasp0_fsx */
+			0x19c (PIN_INPUT_PULLUP | MUX_MODE2)	/* mcasp0_ahclkr.mcasp0_axr2 */
+			0x1ac (PIN_INPUT_PULLUP | MUX_MODE2)	/* mcasp0_ahclkx.mcasp0_axr3 */
+		>;
+	};
+};
+
+&i2c2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
+
+	status = "okay";
+	clock-frequency = <100000>;
+
+	tlv320aic3106: tlv320aic3106@1b {
+		compatible = "ti,tlv320aic3106";
+		reg = <0x1b>;
+		status = "okay";
+
+		/* Regulators */
+		AVDD-supply = <&vmmcsd_fixed>;
+		IOVDD-supply = <&vmmcsd_fixed>;
+		DRVDD-supply = <&vmmcsd_fixed>;
+		DVDD-supply = <&vdd1v8_fixed>;
+	};
+};
+
+&mcasp0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&bone_audio_cape_pins>;
+
+	status = "okay";
+
+	op-mode = <0>;      /* MCASP_IIS_MODE */
+	tdm-slots = <2>;
+	serial-dir = <      /* 0: INACTIVE, 1: TX, 2: RX */
+		0 0 2 1
+	>;
+	tx-num-evt = <1>;
+	rx-num-evt = <1>;
+};
diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index e3f27ec..c1c0f74 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -62,12 +62,26 @@
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 	};
+
+	vdd1v8_fixed: fixedregulator@1 {
+		compatible = "regulator-fixed";
+		regulator-name = "vdd1v8_fixed";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+	};
 };
 
 &am33xx_pinmux {
 	pinctrl-names = "default";
 	pinctrl-0 = <&clkout2_pin>;
 
+	i2c2_pins: pinmux_i2c2_pins {
+		pinctrl-single,pins = <
+			0x178 (PIN_INPUT_PULLUP | MUX_MODE3)  /* uart1_ctsn.i2c2_sda */
+			0x17c (PIN_INPUT_PULLUP | MUX_MODE3)  /* uart1_rtsn.i2c2_scl */
+		>;
+	};
+
 	user_leds_s0: user_leds_s0 {
 		pinctrl-single,pins = <
 			0x54 (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a5.gpio1_21 */
-- 
1.8.5.2

