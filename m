Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3AYIy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:54:29 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:46534 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3AYIyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:54:24 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Brian Lilly <brian@crystalfontz.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ARM: dts: mxs: Add the LCD to the 10049 board
Date: Fri, 25 Jan 2013 09:54:07 +0100
Message-Id: <1359104048-26823-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359104048-26823-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359104048-26823-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10049.dts |   99 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-mxs/mach-mxs.c         |   22 ++++++++
 2 files changed, 121 insertions(+)

diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
index dd91244..cabc33a 100644
--- a/arch/arm/boot/dts/imx28-cfa10049.dts
+++ b/arch/arm/boot/dts/imx28-cfa10049.dts
@@ -30,9 +30,11 @@
 					reg = <0>;
 					fsl,pinmux-ids = <
 						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
+						0x1153 /* MX28_PAD_LCD_D22__GPIO_1_21 */
 						0x1163 /* MX28_PAD_LCD_D22__GPIO_1_22 */
 						0x1173 /* MX28_PAD_LCD_D22__GPIO_1_23 */
 						0x2153 /* MX28_PAD_SSP2_D5__GPIO_2_21 */
+						0x3173 /* MX28_PAD_LCD_RESET__GPIO_3_23 */
 					>;
 					fsl,drive-strength = <0>;
 					fsl,voltage = <1>;
@@ -43,12 +45,25 @@
 					reg = <0>;
 					fsl,pinmux-ids = <
 						0x2133 /* MX28_PAD_SSP2_D3__GPIO_2_19 */
+						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
 					>;
 					fsl,drive-strength = <0>;
 					fsl,voltage = <1>;
 					fsl,pull-up = <1>;
 				};
 
+				spi2_pins_cfa10049: spi2-cfa10049@0 {
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
 				spi3_pins_cfa10049: spi3-cfa10049@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
@@ -62,10 +77,63 @@
 					fsl,voltage = <1>;
 					fsl,pull-up = <1>;
 				};
+
+				lcdif_18bit_pins_cfa10049: lcdif-18bit@0 {
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
+				lcdif_pins_cfa10049: lcdif-evk@0 {
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
+				pinctrl-0 = <&lcdif_18bit_pins_cfa10049
+					     &lcdif_pins_cfa10049>;
+				status = "okay";
 			};
 		};
 
 		apbx@80040000 {
+			pwm: pwm@80064000 {
+				pinctrl-names = "default", "default";
+				pinctrl-1 = <&pwm3_pins_b>;
+				status = "okay";
+			};
+
 			i2c1: i2c@8005a000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&i2c1_pins_a>;
@@ -147,6 +215,30 @@
 		};
 	};
 
+	spi2 {
+		compatible = "spi-gpio";
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi2_pins_cfa10049>;
+		status = "okay";
+		gpio-sck = <&gpio2 16 0>;
+		gpio-mosi = <&gpio2 17 0>;
+		gpio-miso = <&gpio2 18 0>;
+		cs-gpios = <&gpio3 23 0>;
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
+			im-gpios = <&gpio5 4 0 &gpio5 5 0 &gpio5 6 0>;
+		};
+	};
+
 	spi3 {
 		compatible = "spi-gpio";
 		pinctrl-names = "default";
@@ -183,4 +275,11 @@
 			spi-max-frequency = <100000>;
 		};
 	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 3 5000000>;
+		brightness-levels = <0 4 8 16 32 64 128 255>;
+		default-brightness-level = <6>;
+	};
 };
diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index c66129b..4668cf7 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -119,6 +119,23 @@ static struct fb_videomode apf28dev_video_modes[] = {
 	},
 };
 
+static struct fb_videomode cfa10049_video_modes[] = {
+	{
+		.name		= "Himax HX8357-B",
+		.refresh	= 60,
+		.xres		= 320,
+		.yres		= 480,
+		.pixclock	= 108506, /* picosecond (9.216 MHz) */
+		.left_margin	= 2,
+		.right_margin	= 2,
+		.upper_margin	= 2,
+		.lower_margin	= 2,
+		.hsync_len	= 15,
+		.vsync_len	= 15,
+		.sync		= FB_SYNC_DATA_ENABLE_HIGH_ACT
+	},
+};
+
 static struct mxsfb_platform_data mxsfb_pdata __initdata;
 
 /*
@@ -393,6 +410,11 @@ static void __init cfa10049_init(void)
 {
 	enable_clk_enet_out();
 	update_fec_mac_prop(OUI_CRYSTALFONTZ);
+
+	mxsfb_pdata.mode_list = cfa10049_video_modes;
+	mxsfb_pdata.mode_count = ARRAY_SIZE(cfa10049_video_modes);
+	mxsfb_pdata.default_bpp = 32;
+	mxsfb_pdata.ld_intf_width = STMLCDIF_18BIT;
 }
 
 static void __init apf28_init(void)
-- 
1.7.10.4

