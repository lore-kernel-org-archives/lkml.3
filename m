Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3FMNoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:44:09 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50151 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab3FMNn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:43:58 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Lilly <brian@crystalfontz.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 4/4] ARM: mxs: dt: Add Crystalfontz CFA-10057 device tree
Date: Thu, 13 Jun 2013 15:43:45 +0200
Message-Id: <1371131025-12200-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Lilly <brian@crystalfontz.com>

The CFA-10057 is a breakout board for the CFA-10036 that has Ethernet,
USB and a 4.3" LCD screen on it.

Signed-off-by: Brian Lilly <brian@crystalfontz.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/Makefile           |   1 +
 arch/arm/boot/dts/imx28-cfa10057.dts | 191 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-mxs/mach-mxs.c         |   3 +-
 3 files changed, 194 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/imx28-cfa10057.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index e26c504..1560a09 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -131,6 +131,7 @@ dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
 	imx28-cfa10037.dtb \
 	imx28-cfa10049.dtb \
 	imx28-cfa10055.dtb \
+	imx28-cfa10057.dtb \
 	imx28-evk.dtb \
 	imx28-m28evk.dtb \
 	imx28-sps1.dtb \
diff --git a/arch/arm/boot/dts/imx28-cfa10057.dts b/arch/arm/boot/dts/imx28-cfa10057.dts
new file mode 100644
index 0000000..2da713c
--- /dev/null
+++ b/arch/arm/boot/dts/imx28-cfa10057.dts
@@ -0,0 +1,191 @@
+/*
+ * Copyright 2013 Crystalfontz America, Inc.
+ * Copyright 2012 Free Electrons
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/*
+ * The CFA-10057 is an expansion board for the CFA-10036 module, thus we
+ * need to include the CFA-10036 DTS.
+ */
+/include/ "imx28-cfa10036.dts"
+
+/ {
+	model = "Crystalfontz CFA-10057 Board";
+	compatible = "crystalfontz,cfa10057", "crystalfontz,cfa10036", "fsl,imx28";
+
+	apb@80000000 {
+		apbh@80000000 {
+			pinctrl@80018000 {
+				pinctrl-names = "default", "default";
+				pinctrl-1 = <&hog_pins_cfa10057
+					&hog_pins_cfa10057_pullup>;
+
+				hog_pins_cfa10057: hog-10057@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
+						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
+				hog_pins_cfa10057_pullup: hog-10057-pullup@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x2133 /* MX28_PAD_SSP2_D3__GPIO_2_19 */
+						0x3183 /* MX28_PAD_I2C0_SCL__GPIO_3_24 */
+						0x3193 /* MX28_PAD_I2C0_SDA__GPIO_3_25 */
+						0x31a3 /* MX28_PAD_SAIF_SDATA0__GPIO_3_26 */
+						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <1>;
+				};
+
+				lcdif_18bit_pins_cfa10057: lcdif-18bit@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x1000 /* MX28_PAD_LCD_D00__LCD_D0 */
+						0x1010 /* MX28_PAD_LCD_D01__LCD_D1 */
+						0x1020 /* MX28_PAD_LCD_D02__LCD_D2 */
+						0x1030 /* MX28_PAD_LCD_D03__LCD_D3 */
+						0x1040 /* MX28_PAD_LCD_D04__LCD_D4 */
+						0x1050 /* MX28_PAD_LCD_D05__LCD_D5 */
+						0x1060 /* MX28_PAD_LCD_D06__LCD_D6 */
+						0x1070 /* MX28_PAD_LCD_D07__LCD_D7 */
+						0x1080 /* MX28_PAD_LCD_D08__LCD_D8 */
+						0x1090 /* MX28_PAD_LCD_D09__LCD_D9 */
+						0x10a0 /* MX28_PAD_LCD_D10__LCD_D10 */
+						0x10b0 /* MX28_PAD_LCD_D11__LCD_D11 */
+						0x10c0 /* MX28_PAD_LCD_D12__LCD_D12 */
+						0x10d0 /* MX28_PAD_LCD_D13__LCD_D13 */
+						0x10e0 /* MX28_PAD_LCD_D14__LCD_D14 */
+						0x10f0 /* MX28_PAD_LCD_D15__LCD_D15 */
+						0x1100 /* MX28_PAD_LCD_D16__LCD_D16 */
+						0x1110 /* MX28_PAD_LCD_D17__LCD_D17 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
+				lcdif_pins_cfa10057: lcdif-evk@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x1181 /* MX28_PAD_LCD_RD_E__LCD_VSYNC */
+						0x1191 /* MX28_PAD_LCD_WR_RWN__LCD_HSYNC */
+						0x11a1 /* MX28_PAD_LCD_RS__LCD_DOTCLK */
+						0x11b1 /* MX28_PAD_LCD_CS__LCD_ENABLE */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+			};
+
+			lcdif@80030000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&lcdif_18bit_pins_cfa10057
+					     &lcdif_pins_cfa10057>;
+				display = <&display>;
+				status = "okay";
+
+				display: display {
+					bits-per-pixel = <32>;
+					bus-width = <18>;
+
+					display-timings {
+						native-mode = <&timing0>;
+						timing0: timing0 {
+							clock-frequency = <30000000>;
+							hactive = <480>;
+							vactive = <800>;
+							hfront-porch = <12>;
+							hback-porch = <2>;
+							vfront-porch = <5>;
+							vback-porch = <3>;
+							hsync-len = <2>;
+							vsync-len = <2>;
+							hsync-active = <0>;
+							vsync-active = <0>;
+							de-active = <1>;
+							pixelclk-active = <1>;
+						};
+					};
+				};
+			};
+		};
+
+		apbx@80040000 {
+			lradc@80050000 {
+				fsl,lradc-touchscreen-wires = <4>;
+				status = "okay";
+			};
+
+			pwm: pwm@80064000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&pwm3_pins_b>;
+				status = "okay";
+			};
+
+			i2c1: i2c@8005a000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&i2c1_pins_a>;
+				status = "okay";
+			};
+
+			usbphy1: usbphy@8007e000 {
+				status = "okay";
+			};
+		};
+	};
+
+	ahb@80080000 {
+		usb1: usb@80090000 {
+			vbus-supply = <&reg_usb1_vbus>;
+			pinctrl-0 = <&usbphy1_pins_a>;
+			pinctrl-names = "default";
+			status = "okay";
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+
+		reg_usb1_vbus: usb1_vbus {
+			compatible = "regulator-fixed";
+			regulator-name = "usb1_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio0 7 1>;
+		};
+	};
+
+	ahb@80080000 {
+		mac0: ethernet@800f0000 {
+			phy-mode = "rmii";
+			pinctrl-names = "default";
+			pinctrl-0 = <&mac0_pins_a>;
+			phy-reset-gpios = <&gpio2 21 0>;
+			phy-reset-duration = <100>;
+			status = "okay";
+		};
+	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 3 5000000>;
+		brightness-levels = <0 4 8 16 32 64 128 255>;
+		default-brightness-level = <7>;
+	};
+};
diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 60b26c6..77280c6 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -365,7 +365,8 @@ static void __init mxs_machine_init(void)
 		apx4devkit_init();
 	else if (of_machine_is_compatible("crystalfontz,cfa10037") ||
 		 of_machine_is_compatible("crystalfontz,cfa10049") ||
-		 of_machine_is_compatible("crystalfontz,cfa10055"))
+		 of_machine_is_compatible("crystalfontz,cfa10055") ||
+		 of_machine_is_compatible("crystalfontz,cfa10057"))
 		crystalfontz_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table,
-- 
1.8.3

