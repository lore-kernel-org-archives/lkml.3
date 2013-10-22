Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3JVRIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:08:11 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45533 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3JVRHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:07:38 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Cc: pisa@cmp.felk.cvut.cz, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH 3/4] ARM: dts: i.MX53: dts for Voipac x53-dmm-668 module
Date: Tue, 22 Oct 2013 19:07:22 +0200
Message-Id: <1382461643-16790-4-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
References: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable UART1 and FEC

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>

 create mode 100644 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi

diff --git a/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi b/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
new file mode 100644
index 0000000..04695c9
--- /dev/null
+++ b/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
@@ -0,0 +1,195 @@
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
+#include "imx53.dtsi"
+
+/ {
+	model = "Voipac i.MX53 X53-DMM-668";
+	compatible = "vp,imx53-dmm-668", "fsl,imx53";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x70000000 0x20000000>;
+	};
+
+	memory@1 {
+		device_type = "memory";
+		reg = <0xb0000000 0x20000000>;
+	};
+
+	regulators {
+		compatible = "simple-bus";
+
+		reg_3p3v: 3p3v {
+			compatible = "regulator-fixed";
+			regulator-name = "3P3V";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
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
+				/* Make DA9053 regulator functional */
+				MX53_PAD_GPIO_16__GPIO7_11	0x80000000
+
+				/* FEC Power enable */
+				MX53_PAD_GPIO_11__GPIO4_1	0x80000000
+
+				/* FEC RST */
+				MX53_PAD_GPIO_12__GPIO4_2	0x80000000
+			>;
+		};
+	};
+};
+
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart1_2>;
+	status = "okay";
+};
+
+&i2c1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c1_2>;
+	status = "okay";
+
+	pmic: dialog@48 {
+		compatible = "dlg,da9053-aa", "dlg,da9052";
+		reg = <0x48>;
+		interrupt-parent = <&gpio7>;
+		interrupts = <11 0x8>; /* low-level active IRQ at GPIO7_11 */
+
+		regulators {
+			buck1_reg: buck1 {
+				regulator-name = "BUCKCORE";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+			};
+
+			buck2_reg: buck2 {
+				regulator-name = "BUCKPRO";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+			};
+
+			buck3_reg: buck3 {
+				regulator-name = "BUCKMEM";
+				regulator-min-microvolt = <1420000>;
+				regulator-max-microvolt = <1580000>;
+				regulator-always-on;
+			};
+
+			buck4_reg: buck4 {
+				regulator-name = "BUCKPERI";
+				regulator-min-microvolt = <2370000>;
+				regulator-max-microvolt = <2630000>;
+				regulator-always-on;
+			};
+
+			ldo1_reg: ldo1 {
+				regulator-name = "ldo1_1v3";
+				regulator-min-microvolt = <1250000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo2_reg: ldo2 {
+				regulator-name = "ldo2_1v3";
+				regulator-min-microvolt = <1250000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+			};
+
+			ldo3_reg: ldo3 {
+				regulator-name = "ldo3_3v3";
+				regulator-min-microvolt = <3250000>;
+				regulator-max-microvolt = <3350000>;
+				regulator-always-on;
+			};
+
+			ldo4_reg: ldo4 {
+				regulator-name = "ldo4_2v775";
+				regulator-min-microvolt = <2770000>;
+				regulator-max-microvolt = <2780000>;
+				regulator-always-on;
+			};
+
+			ldo5_reg: ldo5 {
+				regulator-name = "ldo5_3v3";
+				regulator-min-microvolt = <3250000>;
+				regulator-max-microvolt = <3350000>;
+				regulator-always-on;
+			};
+
+			ldo6_reg: ldo6 {
+				regulator-name = "ldo6_1v3";
+				regulator-min-microvolt = <1250000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+			};
+
+			ldo7_reg: ldo7 {
+				regulator-name = "ldo7_2v75";
+				regulator-min-microvolt = <2700000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+			};
+
+			ldo8_reg: ldo8 {
+				regulator-name = "ldo8_1v8";
+				regulator-min-microvolt = <1750000>;
+				regulator-max-microvolt = <1850000>;
+				regulator-always-on;
+			};
+
+			ldo9_reg: ldo9 {
+				regulator-name = "ldo9_1v5";
+				regulator-min-microvolt = <1450000>;
+				regulator-max-microvolt = <1550000>;
+				regulator-always-on;
+			};
+
+			ldo10_reg: ldo10 {
+				regulator-name = "ldo10_1v3";
+				regulator-min-microvolt = <1250000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+			};
+		};
+	};
+};
+
+&ecspi1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_ecspi1_1>;
+	fsl,spi-num-chipselects = <4>;
+	cs-gpios = <&gpio2 30 0>, <&gpio3 19 0>, <&gpio2 16 0>, <&gpio2 17 0>;
+	status = "okay";
+};
+
+&fec {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_fec_1>;
+	phy-mode = "rmii";
+	phy-reset-gpios = <&gpio4 2 0>;
+	status = "okay";
+};
-- 
1.7.10.4

