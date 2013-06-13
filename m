Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3FMNn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:43:59 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50145 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3FMNn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:43:57 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Lilly <brian@crystalfontz.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/4] ARM: mxs: dt: Add the Crystalfontz CFA-10055 device tree
Date: Thu, 13 Jun 2013 15:43:44 +0200
Message-Id: <1371131025-12200-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Lilly <brian@crystalfontz.com>

The CFA-10055 is yet another breakout board for the CFA-10036, and is
basically a CFA-10037, with the screen and LCD controller found on the
CFA-10049.

Signed-off-by: Brian Lilly <brian@crystalfontz.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/Makefile           |   1 +
 arch/arm/boot/dts/imx28-cfa10055.dts | 179 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-mxs/mach-mxs.c         |  15 +--
 3 files changed, 185 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/boot/dts/imx28-cfa10055.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b9f7121..e26c504 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -130,6 +130,7 @@ dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
 	imx28-cfa10036.dtb \
 	imx28-cfa10037.dtb \
 	imx28-cfa10049.dtb \
+	imx28-cfa10055.dtb \
 	imx28-evk.dtb \
 	imx28-m28evk.dtb \
 	imx28-sps1.dtb \
diff --git a/arch/arm/boot/dts/imx28-cfa10055.dts b/arch/arm/boot/dts/imx28-cfa10055.dts
new file mode 100644
index 0000000..1581112
--- /dev/null
+++ b/arch/arm/boot/dts/imx28-cfa10055.dts
@@ -0,0 +1,179 @@
+/*
+ * Copyright 2013 Crystalfontz America, Inc.
+ * 				  Free Electrons
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
+ * The CFA-10055 is an expansion board for the CFA-10036 module and
+ * CFA-10037, thus we need to include the CFA-10037 DTS.
+ */
+/include/ "imx28-cfa10037.dts"
+
+/ {
+	model = "Crystalfontz CFA-10055 Board";
+	compatible = "crystalfontz,cfa10055", "crystalfontz,cfa10037", "crystalfontz,cfa10036", "fsl,imx28";
+
+	apb@80000000 {
+		apbh@80000000 {
+			pinctrl@80018000 {
+				pinctrl-names = "default", "default";
+				pinctrl-1 = <&hog_pins_cfa10055
+					&hog_pins_cfa10055_pullup>;
+
+				hog_pins_cfa10055: hog-10055@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
+				hog_pins_cfa10055_pullup: hog-10055-pullup@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <1>;
+				};
+
+				spi2_pins_cfa10055: spi2-cfa10055@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x2103 /* MX28_PAD_SSP2_SCK__GPIO_2_16 */
+						0x2113 /* MX28_PAD_SSP2_CMD__GPIO_2_17 */
+						0x2123 /* MX28_PAD_SSP2_D0__GPIO_2_18 */
+					>;
+					fsl,drive-strength = <1>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <1>;
+				};
+
+				lcdif_18bit_pins_cfa10055: lcdif-18bit@0 {
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
+				lcdif_pins_cfa10055: lcdif-evk@0 {
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
+				pinctrl-0 = <&lcdif_18bit_pins_cfa10055
+					     &lcdif_pins_cfa10055>;
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
+							clock-frequency = <9216000>;
+							hactive = <320>;
+							vactive = <480>;
+							hback-porch = <2>;
+							hfront-porch = <2>;
+							vback-porch = <2>;
+							vfront-porch = <2>;
+							hsync-len = <15>;
+							vsync-len = <15>;
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
+		};
+	};
+
+	spi2 {
+		compatible = "spi-gpio";
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi2_pins_cfa10055>;
+		status = "okay";
+		gpio-sck = <&gpio2 16 0>;
+		gpio-mosi = <&gpio2 17 0>;
+		gpio-miso = <&gpio2 18 0>;
+		cs-gpios = <&gpio3 5 0>;
+		num-chipselects = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		hx8357: hx8357@0 {
+			compatible = "himax,hx8357b", "himax,hx8357";
+			reg = <0>;
+			spi-max-frequency = <100000>;
+			spi-cpol;
+			spi-cpha;
+			gpios-reset = <&gpio3 30 0>;
+		};
+	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 3 5000000>;
+		brightness-levels = <0 4 8 16 32 64 128 255>;
+		default-brightness-level = <6>;
+	};
+};
diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 5b62b64..60b26c6 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -352,12 +352,7 @@ static void __init tx28_post_init(void)
 	pinctrl_put(pctl);
 }
 
-static void __init cfa10049_init(void)
-{
-	update_fec_mac_prop(OUI_CRYSTALFONTZ);
-}
-
-static void __init cfa10037_init(void)
+static void __init crystalfontz_init(void)
 {
 	update_fec_mac_prop(OUI_CRYSTALFONTZ);
 }
@@ -368,10 +363,10 @@ static void __init mxs_machine_init(void)
 		imx28_evk_init();
 	else if (of_machine_is_compatible("bluegiga,apx4devkit"))
 		apx4devkit_init();
-	else if (of_machine_is_compatible("crystalfontz,cfa10037"))
-		cfa10037_init();
-	else if (of_machine_is_compatible("crystalfontz,cfa10049"))
-		cfa10049_init();
+	else if (of_machine_is_compatible("crystalfontz,cfa10037") ||
+		 of_machine_is_compatible("crystalfontz,cfa10049") ||
+		 of_machine_is_compatible("crystalfontz,cfa10055"))
+		crystalfontz_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table,
 			     mxs_auxdata_lookup, NULL);
-- 
1.8.3

