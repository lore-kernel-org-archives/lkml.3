Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3GANXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:23:44 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40881 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3GANXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:23:41 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 5/8] ARM: mxs: dt: cfa10049: make hogpins grabbed by respective drivers
Date: Mon,  1 Jul 2013 15:23:26 +0200
Message-Id: <1372685009-15564-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372685009-15564-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372685009-15564-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10049.dts | 73 +++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
index 04b2f76..06e4cfa 100644
--- a/arch/arm/boot/dts/imx28-cfa10049.dts
+++ b/arch/arm/boot/dts/imx28-cfa10049.dts
@@ -22,32 +22,62 @@
 	apb@80000000 {
 		apbh@80000000 {
 			pinctrl@80018000 {
-				pinctrl-names = "default", "default";
-				pinctrl-1 = <&hog_pins_cfa10049
-					&hog_pins_cfa10049_pullup>;
-
-				hog_pins_cfa10049: hog-10049@0 {
+				usb_pins_cfa10049: usb-10049@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
 						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
+				i2cmux_pins_cfa10049: i2cmux-10049@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
 						0x1163 /* MX28_PAD_LCD_D22__GPIO_1_22 */
 						0x1173 /* MX28_PAD_LCD_D22__GPIO_1_23 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
+				mac0_pins_cfa10049: mac0-10049@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
 						0x2153 /* MX28_PAD_SSP2_D5__GPIO_2_21 */
-						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */
 					>;
 					fsl,drive-strength = <0>;
 					fsl,voltage = <1>;
 					fsl,pull-up = <0>;
 				};
 
-				hog_pins_cfa10049_pullup: hog-10049-pullup@0 {
+				pca_pins_cfa10049: pca-10049@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
 						0x2133 /* MX28_PAD_SSP2_D3__GPIO_2_19 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <1>;
+				};
+
+				rotary_pins_cfa10049: rotary-10049@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
 						0x3183 /* MX28_PAD_I2C0_SCL__GPIO_3_24 */
 						0x3193 /* MX28_PAD_I2C0_SDA__GPIO_3_25 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <1>;
+				};
+
+				rotary_btn_pins_cfa10049: rotary-btn-10049@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
 						0x31a3 /* MX28_PAD_SAIF_SDATA0__GPIO_3_26 */
-						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
 					>;
 					fsl,drive-strength = <0>;
 					fsl,voltage = <1>;
@@ -60,6 +90,7 @@
 						0x2103 /* MX28_PAD_SSP2_SCK__GPIO_2_16 */
 						0x2113 /* MX28_PAD_SSP2_CMD__GPIO_2_17 */
 						0x2123 /* MX28_PAD_SSP2_D0__GPIO_2_18 */
+						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */
 					>;
 					fsl,drive-strength = <1>;
 					fsl,voltage = <1>;
@@ -120,6 +151,16 @@
 					fsl,pull-up = <0>;
 				};
 
+				lcdif_pins_cfa10049_pullup: lcdif-10049-pullup@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <1>;
+				};
+
 				w1_gpio_pins: w1-gpio@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
@@ -134,7 +175,8 @@
 			lcdif@80030000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&lcdif_18bit_pins_cfa10049
-					     &lcdif_pins_cfa10049>;
+					     &lcdif_pins_cfa10049
+					     &lcdif_pins_cfa10049_pullup>;
 				display = <&display>;
 				status = "okay";
 
@@ -181,6 +223,8 @@
 				compatible = "i2c-mux-gpio";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&i2cmux_pins_cfa10049>;
 				mux-gpios = <&gpio1 22 0 &gpio1 23 0>;
 				i2c-parent = <&i2c1>;
 
@@ -203,6 +247,8 @@
 
 					pca9555: pca9555@20 {
 						compatible = "nxp,pca9555";
+						pinctrl-names = "default";
+						pinctrl-0 = <&pca_pins_cfa10049>;
 						interrupt-parent = <&gpio2>;
 						interrupts = <19 0x2>;
 						gpio-controller;
@@ -239,6 +285,8 @@
 
 		reg_usb1_vbus: usb1_vbus {
 			compatible = "regulator-fixed";
+			pinctrl-names = "default";
+			pinctrl-0 = <&usb_pins_cfa10049>;
 			regulator-name = "usb1_vbus";
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
@@ -250,7 +298,8 @@
 		mac0: ethernet@800f0000 {
 			phy-mode = "rmii";
 			pinctrl-names = "default";
-			pinctrl-0 = <&mac0_pins_a>;
+			pinctrl-0 = <&mac0_pins_a
+				&mac0_pins_cfa10049>;
 			phy-reset-gpios = <&gpio2 21 0>;
 			phy-reset-duration = <100>;
 			status = "okay";
@@ -320,6 +369,8 @@
 
 	gpio_keys {
 		compatible = "gpio-keys";
+		pinctrl-names = "default";
+		pinctrl-0 = <&rotary_btn_pins_cfa10049>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 
@@ -333,6 +384,8 @@
 
 	rotary {
 		compatible = "rotary-encoder";
+		pinctrl-names = "default";
+		pinctrl-0 = <&rotary_pins_cfa10049>;
 		gpios = <&gpio3 24 1>, <&gpio3 25 1>;
 		linux,axis = <1>; /* REL_Y */
 		rotary-encoder,relative-axis;
-- 
1.8.1.2

