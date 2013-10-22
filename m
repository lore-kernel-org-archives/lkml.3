Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3JVRHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:07:44 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:62843 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab3JVRHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:07:40 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Cc: pisa@cmp.felk.cvut.cz, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH 4/4] ARM: dts: i.MX53: Devicetree for Voipac Baseboard using x53-dmm-668 module
Date: Tue, 22 Oct 2013 19:07:23 +0200
Message-Id: <1382461643-16790-5-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
References: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supported peripherals: Audio -- headphone output, LEDs, Buttons
(using keyboard controller), SD-card.

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>

 create mode 100644 arch/arm/boot/dts/imx53-voipac-bsb.dts

diff --git a/arch/arm/boot/dts/imx53-voipac-bsb.dts b/arch/arm/boot/dts/imx53-voipac-bsb.dts
new file mode 100644
index 0000000..7b48462
--- /dev/null
+++ b/arch/arm/boot/dts/imx53-voipac-bsb.dts
@@ -0,0 +1,135 @@
+/*
+ * Copyright 2013 Rostislav Lisovy <lisovy@gmail.com>, PiKRON s.r.o.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+#include "imx53-voipac-dmm-668.dtsi"
+
+/ {
+	sound {
+		compatible = "fsl,imx53-voipac-sgtl5000",
+			     "fsl,imx-audio-sgtl5000";
+		model = "imx53-voipac-sgtl5000";
+		ssi-controller = <&ssi2>;
+		audio-codec = <&sgtl5000>;
+		audio-routing =
+			"Headphone Jack", "HP_OUT";
+		mux-int-port = <2>;
+		mux-ext-port = <5>;
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&led_pin_gpio>;
+
+		led1 {
+			label = "led-red";
+			gpios = <&gpio3 29 0>;
+			default-state = "off";
+		};
+
+		led2 {
+			label = "led-orange";
+			gpios = <&gpio2 31 0>;
+			default-state = "off";
+		};
+	};
+};
+
+&iomuxc {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_hog>;
+
+	hog {
+		pinctrl_hog: hoggrp {
+			fsl,pins = <
+				/* SD2_CD */
+				MX53_PAD_EIM_D25__GPIO3_25	0x80000000
+				/* SD2_WP */
+				MX53_PAD_EIM_A19__GPIO2_19 	0x80000000
+			>;
+		};
+
+		led_pin_gpio: led_gpio@0 {
+			fsl,pins = <
+				MX53_PAD_EIM_D29__GPIO3_29	0x80000000
+				MX53_PAD_EIM_EB3__GPIO2_31	0x80000000
+			>;
+		};
+	};
+
+	/* Keyboard controller */
+	kpp {
+		pinctrl_kpp_1: kppgrp-1 {
+			fsl,pins = <
+				MX53_PAD_GPIO_9__KPP_COL_6	0xe8
+				MX53_PAD_GPIO_4__KPP_COL_7	0xe8
+				MX53_PAD_KEY_COL2__KPP_COL_2	0xe8
+				MX53_PAD_KEY_COL3__KPP_COL_3	0xe8
+				MX53_PAD_KEY_COL4__KPP_COL_4	0xe8
+
+				MX53_PAD_GPIO_2__KPP_ROW_6	0xe0
+				MX53_PAD_GPIO_5__KPP_ROW_7	0xe0
+				MX53_PAD_KEY_ROW2__KPP_ROW_2	0xe0
+				MX53_PAD_KEY_ROW3__KPP_ROW_3	0xe0
+				MX53_PAD_KEY_ROW4__KPP_ROW_4	0xe0
+			>;
+		};
+	};
+};
+
+&i2c3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c3_2>;
+	status = "okay";
+
+	sgtl5000: codec@0a {
+		compatible = "fsl,sgtl5000";
+		reg = <0x0a>;
+		VDDA-supply = <&reg_3p3v>;
+		VDDIO-supply = <&reg_3p3v>;
+		clocks = <&clks 150>;
+	};
+};
+
+&kpp {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_kpp_1>;
+	linux,keymap = <
+			0x0203003b	/* KEY_F1 */
+			0x0603003c	/* KEY_F2 */
+			0x0207003d	/* KEY_F3 */
+			0x0607003e	/* KEY_F4 */
+			>;
+	keypad,num-rows = <8>;
+	keypad,num-columns = <8>;
+	status = "okay";
+};
+
+&ssi2 {
+	fsl,mode = "i2s-slave";
+	status = "okay";
+};
+
+&audmux {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_audmux_1>; /* SSI1 */
+	status = "okay";
+};
+
+&esdhc2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_esdhc2_1>;
+	cd-gpios = <&gpio3 25 0>;
+	wp-gpios = <&gpio2 19 0>;
+	vmmc-supply = <&reg_3p3v>;
+	status = "okay";
+};
-- 
1.7.10.4

