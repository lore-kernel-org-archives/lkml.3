Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3G2MaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:30:00 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:36775 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab3G2M3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:29:18 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ARM: dove: add common pinmux functions to DT
Date: Mon, 29 Jul 2013 14:29:04 +0200
Message-Id: <1375100946-28521-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375100946-28521-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375100946-28521-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds common dedicated and gpio pinmux functions to SoC pinctrl
node. It also relocates pinctrl references to corresponding DT nodes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove-cubox.dts |   23 +----
 arch/arm/boot/dts/dove.dtsi      |  183 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index 955188f..525fb45 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -42,6 +42,8 @@
 			regulator-always-on;
 			regulator-boot-on;
 			gpio = <&gpio0 1 0>;
+			pinctrl-0 = <&pmx_gpio_1>;
+			pinctrl-names = "default";
 		};
 	};
 
@@ -110,6 +112,7 @@
 	status = "okay";
 	/* sdio0 card detect is connected to wrong pin on CuBox */
 	cd-gpios = <&gpio0 12 1>;
+	pinctrl-0 = <&pmx_sdio0 &pmx_gpio_12>;
 };
 
 &spi0 {
@@ -122,23 +125,3 @@
 		reg = <0>;
 	};
 };
-
-&pinctrl {
-	pinctrl-0 = <&pmx_gpio_1 &pmx_gpio_12>;
-	pinctrl-names = "default";
-
-	pmx_gpio_1: pmx-gpio-1 {
-		marvell,pins = "mpp1";
-		marvell,function = "gpio";
-	};
-
-	pmx_gpio_12: pmx-gpio-12 {
-		marvell,pins = "mpp12";
-		marvell,function = "gpio";
-	};
-
-	pmx_gpio_18: pmx-gpio-18 {
-		marvell,pins = "mpp18";
-		marvell,function = "gpio";
-	};
-};
diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 09d9710..90257c7 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -99,6 +99,8 @@
 			reg-shift = <2>;
 			interrupts = <8>;
 			clocks = <&core_clk 0>;
+			pinctrl-0 = <&pmx_uart1>;
+			pinctrl-names = "default";
 			status = "disabled";
 		};
 
@@ -154,6 +156,181 @@
 			compatible = "marvell,dove-pinctrl";
 			reg = <0xd0200 0x10>;
 			clocks = <&gate_clk 22>;
+
+			pmx_gpio_0: pmx-gpio-0 {
+				marvell,pins = "mpp0";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_1: pmx-gpio-1 {
+				marvell,pins = "mpp1";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_2: pmx-gpio-2 {
+				marvell,pins = "mpp2";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_3: pmx-gpio-3 {
+				marvell,pins = "mpp3";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_4: pmx-gpio-4 {
+				marvell,pins = "mpp4";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_5: pmx-gpio-5 {
+				marvell,pins = "mpp5";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_6: pmx-gpio-6 {
+				marvell,pins = "mpp6";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_7: pmx-gpio-7 {
+				marvell,pins = "mpp7";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_8: pmx-gpio-8 {
+				marvell,pins = "mpp8";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_9: pmx-gpio-9 {
+				marvell,pins = "mpp9";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_10: pmx-gpio-10 {
+				marvell,pins = "mpp10";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_11: pmx-gpio-11 {
+				marvell,pins = "mpp11";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_12: pmx-gpio-12 {
+				marvell,pins = "mpp12";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_13: pmx-gpio-13 {
+				marvell,pins = "mpp13";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_14: pmx-gpio-14 {
+				marvell,pins = "mpp14";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_15: pmx-gpio-15 {
+				marvell,pins = "mpp15";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_16: pmx-gpio-16 {
+				marvell,pins = "mpp16";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_17: pmx-gpio-17 {
+				marvell,pins = "mpp17";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_18: pmx-gpio-18 {
+				marvell,pins = "mpp18";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_19: pmx-gpio-19 {
+				marvell,pins = "mpp19";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_20: pmx-gpio-20 {
+				marvell,pins = "mpp20";
+				marvell,function = "gpio";
+			};
+
+			pmx_gpio_21: pmx-gpio-21 {
+				marvell,pins = "mpp21";
+				marvell,function = "gpio";
+			};
+
+			pmx_camera: pmx-camera {
+				marvell,pins = "mpp_camera";
+				marvell,function = "camera";
+			};
+
+			pmx_camera_gpio: pmx-camera-gpio {
+				marvell,pins = "mpp_camera";
+				marvell,function = "gpio";
+			};
+
+			pmx_sdio0: pmx-sdio0 {
+				marvell,pins = "mpp_sdio0";
+				marvell,function = "sdio0";
+			};
+
+			pmx_sdio0_gpio: pmx-sdio0-gpio {
+				marvell,pins = "mpp_sdio0";
+				marvell,function = "gpio";
+			};
+
+			pmx_sdio1: pmx-sdio1 {
+				marvell,pins = "mpp_sdio1";
+				marvell,function = "sdio1";
+			};
+
+			pmx_sdio1_gpio: pmx-sdio1-gpio {
+				marvell,pins = "mpp_sdio1";
+				marvell,function = "gpio";
+			};
+
+			pmx_audio1_gpio: pmx-audio1-gpio {
+				marvell,pins = "mpp_audio1";
+				marvell,function = "gpio";
+			};
+
+			pmx_spi0: pmx-spi0 {
+				marvell,pins = "mpp_spi0";
+				marvell,function = "spi0";
+			};
+
+			pmx_spi0_gpio: pmx-spi0-gpio {
+				marvell,pins = "mpp_spi0";
+				marvell,function = "gpio";
+			};
+
+			pmx_uart1: pmx-uart1 {
+				marvell,pins = "mpp_uart1";
+				marvell,function = "uart1";
+			};
+
+			pmx_uart1_gpio: pmx-uart1-gpio {
+				marvell,pins = "mpp_uart1";
+				marvell,function = "gpio";
+			};
+
+			pmx_nand: pmx-nand {
+				marvell,pins = "mpp_nand";
+				marvell,function = "nand";
+			};
+
+			pmx_nand_gpo: pmx-nand-gpo {
+				marvell,pins = "mpp_nand";
+				marvell,function = "gpo";
+			};
 		};
 
 		spi0: spi-ctrl@10600 {
@@ -164,6 +341,8 @@
 			interrupts = <6>;
 			reg = <0x10600 0x28>;
 			clocks = <&core_clk 0>;
+			pinctrl-0 = <&pmx_spi0>;
+			pinctrl-names = "default";
 			status = "disabled";
 		};
 
@@ -211,6 +390,8 @@
 			reg = <0x92000 0x100>;
 			interrupts = <35>, <37>;
 			clocks = <&gate_clk 8>;
+			pinctrl-0 = <&pmx_sdio0>;
+			pinctrl-names = "default";
 			status = "disabled";
 		};
 
@@ -219,6 +400,8 @@
 			reg = <0x90000 0x100>;
 			interrupts = <36>, <38>;
 			clocks = <&gate_clk 9>;
+			pinctrl-0 = <&pmx_sdio1>;
+			pinctrl-names = "default";
 			status = "disabled";
 		};
 
-- 
1.7.10.4

