Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaHAE7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 00:59:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbaHAE4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 00:56:54 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 03/10] ARM: dts: Clean up exynos5250-snow
Date: Fri,  1 Aug 2014 06:54:50 +0200
Message-Id: <1406868897-26874-4-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406868897-26874-1-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new style of referencing inherited nodes and use symbolic names.
Reorder one pinctrl node in GPIO order.

Goal is the alignment of all exynos5250 based device trees for comparison.

Suggested-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v4 -> v5:
 * Introduced labels to consistently use new referencing style (Tomasz)
 * Use IRQ_TYPE_* constants
 * Use some more GPIO_ACTIVE_*

 v3 -> v4: Unchanged
 
 v3: New (Doug Anderson)

 arch/arm/boot/dts/exynos5250-snow.dts | 291 +++++++++++++++++-----------------
 arch/arm/boot/dts/exynos5250.dtsi     |  20 +--
 2 files changed, 155 insertions(+), 156 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 1c36cd72905f..7680d5e03fb3 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -6,9 +6,12 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
-*/
+ */
 
 /dts-v1/;
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/input/input.h>
 #include "exynos5250.dtsi"
 
 / {
@@ -26,89 +29,19 @@
 	chosen {
 	};
 
-	rtc@101E0000 {
-		status = "okay";
-	};
-
-	pinctrl@11400000 {
-		ec_irq: ec-irq {
-			samsung,pins = "gpx1-6";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <0>;
-			samsung,pin-drv = <0>;
-		};
-
-		sd3_clk: sd3-clk {
-			samsung,pin-drv = <0>;
-		};
-
-		sd3_cmd: sd3-cmd {
-			samsung,pin-pud = <3>;
-			samsung,pin-drv = <0>;
-		};
-
-		sd3_bus4: sd3-bus-width4 {
-			samsung,pin-drv = <0>;
-		};
-
-		max98095_en: max98095-en {
-			samsung,pins = "gpx1-7";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <3>;
-			samsung,pin-drv = <0>;
-		};
-
-		tps65090_irq: tps65090-irq {
-			samsung,pins = "gpx2-6";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <0>;
-			samsung,pin-drv = <0>;
-		};
-
-		usb3_vbus_en: usb3-vbus-en {
-			samsung,pins = "gpx2-7";
-			samsung,pin-function = <1>;
-			samsung,pin-pud = <0>;
-			samsung,pin-drv = <0>;
-		};
-
-		hdmi_hpd_irq: hdmi-hpd-irq {
-			samsung,pins = "gpx3-7";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <1>;
-			samsung,pin-drv = <0>;
-		};
-	};
-
-	pinctrl@13400000 {
-		arb_their_claim: arb-their-claim {
-			samsung,pins = "gpe0-4";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <3>;
-			samsung,pin-drv = <0>;
-		};
-
-		arb_our_claim: arb-our-claim {
-			samsung,pins = "gpf0-3";
-			samsung,pin-function = <1>;
-			samsung,pin-pud = <0>;
-			samsung,pin-drv = <0>;
-		};
-	};
-
 	gpio-keys {
 		compatible = "gpio-keys";
 
 		power {
 			label = "Power";
-			gpios = <&gpx1 3 1>;
-			linux,code = <116>; /* KEY_POWER */
+			gpios = <&gpx1 3 GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_POWER>;
 			gpio-key,wakeup;
 		};
 
 		lid-switch {
 			label = "Lid";
-			gpios = <&gpx3 5 1>;
+			gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
 			linux,input-type = <5>; /* EV_SW */
 			linux,code = <0>; /* SW_LID */
 			debounce-interval = <1>;
@@ -129,8 +62,8 @@
 
 		i2c-parent = <&{/i2c@12CA0000}>;
 
-		our-claim-gpio = <&gpf0 3 1>;
-		their-claim-gpios = <&gpe0 4 1>;
+		our-claim-gpio = <&gpf0 3 GPIO_ACTIVE_LOW>;
+		their-claim-gpios = <&gpe0 4 GPIO_ACTIVE_LOW>;
 		slew-delay-us = <10>;
 		wait-retry-us = <3000>;
 		wait-free-us = <50000>;
@@ -153,7 +86,7 @@
 			cros_ec: embedded-controller {
 				compatible = "google,cros-ec-i2c";
 				reg = <0x1e>;
-				interrupts = <6 0>;
+				interrupts = <6 IRQ_TYPE_NONE>;
 				interrupt-parent = <&gpx1>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&ec_irq>;
@@ -239,19 +172,6 @@
 		};
 	};
 
-	i2c@12CD0000 {
-		max98095: codec@11 {
-			compatible = "maxim,max98095";
-			reg = <0x11>;
-			pinctrl-0 = <&max98095_en>;
-			pinctrl-names = "default";
-		};
-	};
-
-	i2s0: i2s@03830000 {
-		status = "okay";
-	};
-
 	sound {
 		compatible = "google,snow-audio-max98095";
 
@@ -265,20 +185,12 @@
 		regulator-name = "P5.0V_USB3CON";
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
-		gpio = <&gpx2 7 0>;
+		gpio = <&gpx2 7 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&usb3_vbus_en>;
 		enable-active-high;
 	};
 
-	phy@12100000 {
-		vbus-supply = <&usb3_vbus_reg>;
-	};
-
-	usb@12110000 {
-		samsung,vbus-gpio = <&gpx1 1 0>;
-	};
-
 	fixed-rate-clocks {
 		xxti {
 			compatible = "samsung,clock-xxti";
@@ -286,19 +198,7 @@
 		};
 	};
 
-	hdmi {
-		hpd-gpio = <&gpx3 7 0>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&hdmi_hpd_irq>;
-		phy = <&hdmiphy>;
-		ddc = <&i2c_2>;
-		hdmi-en-supply = <&tps65090_fet7>;
-		vdd-supply = <&ldo8_reg>;
-		vdd_osc-supply = <&ldo10_reg>;
-		vdd_pll-supply = <&ldo8_reg>;
-	};
-
-	backlight {
+	backlight: backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pwm 0 1000000 0>;
 		brightness-levels = <0 100 500 1000 1500 2000 2500 2800>;
@@ -306,42 +206,58 @@
 		pinctrl-0 = <&pwm0_out>;
 		pinctrl-names = "default";
 	};
+};
 
-	fimd@14400000 {
-		status = "okay";
-		samsung,invert-vclk;
-	};
-
-	dp-controller@145B0000 {
-		status = "okay";
-		pinctrl-names = "default";
-		pinctrl-0 = <&dp_hpd>;
-		samsung,color-space = <0>;
-		samsung,dynamic-range = <0>;
-		samsung,ycbcr-coeff = <0>;
-		samsung,color-depth = <1>;
-		samsung,link-rate = <0x0a>;
-		samsung,lane-count = <2>;
-		samsung,hpd-gpio = <&gpx0 7 0>;
-
-		display-timings {
-			native-mode = <&timing1>;
-
-			timing1: timing@1 {
-				clock-frequency = <70589280>;
-				hactive = <1366>;
-				vactive = <768>;
-				hfront-porch = <40>;
-				hback-porch = <40>;
-				hsync-len = <32>;
-				vback-porch = <10>;
-				vfront-porch = <12>;
-				vsync-len = <6>;
-			};
+&dp {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&dp_hpd>;
+	samsung,color-space = <0>;
+	samsung,dynamic-range = <0>;
+	samsung,ycbcr-coeff = <0>;
+	samsung,color-depth = <1>;
+	samsung,link-rate = <0x0a>;
+	samsung,lane-count = <2>;
+	samsung,hpd-gpio = <&gpx0 7 GPIO_ACTIVE_HIGH>;
+
+	display-timings {
+		native-mode = <&timing1>;
+
+		timing1: timing@1 {
+			clock-frequency = <70589280>;
+			hactive = <1366>;
+			vactive = <768>;
+			hfront-porch = <40>;
+			hback-porch = <40>;
+			hsync-len = <32>;
+			vback-porch = <10>;
+			vfront-porch = <12>;
+			vsync-len = <6>;
 		};
 	};
 };
 
+&ehci {
+	samsung,vbus-gpio = <&gpx1 1 GPIO_ACTIVE_HIGH>;
+};
+
+&fimd {
+	status = "okay";
+	samsung,invert-vclk;
+};
+
+&hdmi {
+	hpd-gpio = <&gpx3 7 GPIO_ACTIVE_HIGH>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&hdmi_hpd_irq>;
+	phy = <&hdmiphy>;
+	ddc = <&i2c_2>;
+	hdmi-en-supply = <&tps65090_fet7>;
+	vdd-supply = <&ldo8_reg>;
+	vdd_osc-supply = <&ldo10_reg>;
+	vdd_pll-supply = <&ldo8_reg>;
+};
+
 &i2c_0 {
 	status = "okay";
 	samsung,i2c-sda-delay = <100>;
@@ -350,7 +266,7 @@
 	max77686@09 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 0>;
+		interrupts = <2 IRQ_TYPE_NONE>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max77686_irq>;
 		wakeup-source;
@@ -500,7 +416,7 @@
 	trackpad {
 		reg = <0x67>;
 		compatible = "cypress,cyapa";
-		interrupts = <2 0>;
+		interrupts = <2 IRQ_TYPE_NONE>;
 		interrupt-parent = <&gpx1>;
 		wakeup-source;
 	};
@@ -547,6 +463,13 @@
 	status = "okay";
 	samsung,i2c-sda-delay = <100>;
 	samsung,i2c-max-bus-freq = <66000>;
+
+	max98095: codec@11 {
+		compatible = "maxim,max98095";
+		reg = <0x11>;
+		pinctrl-0 = <&max98095_en>;
+		pinctrl-names = "default";
+	};
 };
 
 &i2c_8 {
@@ -560,6 +483,10 @@
 	};
 };
 
+&i2s0 {
+	status = "okay";
+};
+
 &mmc_0 {
 	status = "okay";
 	num-slots = <1>;
@@ -592,7 +519,7 @@
 	slot@0 {
 		reg = <0>;
 		bus-width = <4>;
-		wp-gpios = <&gpc2 1 0>;
+		wp-gpios = <&gpc2 1 GPIO_ACTIVE_HIGH>;
 	};
 };
 
@@ -619,12 +546,80 @@
 };
 
 &pinctrl_0 {
+	ec_irq: ec-irq {
+		samsung,pins = "gpx1-6";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	max98095_en: max98095-en {
+		samsung,pins = "gpx1-7";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	tps65090_irq: tps65090-irq {
+		samsung,pins = "gpx2-6";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	usb3_vbus_en: usb3-vbus-en {
+		samsung,pins = "gpx2-7";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	max77686_irq: max77686-irq {
 		samsung,pins = "gpx3-2";
 		samsung,pin-function = <0>;
 		samsung,pin-pud = <0>;
 		samsung,pin-drv = <0>;
 	};
+
+	hdmi_hpd_irq: hdmi-hpd-irq {
+		samsung,pins = "gpx3-7";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&pinctrl_1 {
+	arb_their_claim: arb-their-claim {
+		samsung,pins = "gpe0-4";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	arb_our_claim: arb-our-claim {
+		samsung,pins = "gpf0-3";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&rtc {
+	status = "okay";
+};
+
+&sd3_clk {
+	samsung,pin-drv = <0>;
+};
+
+&sd3_cmd {
+	samsung,pin-pud = <3>;
+	samsung,pin-drv = <0>;
+};
+
+&sd3_bus4 {
+	samsung,pin-drv = <0>;
 };
 
 &spi_1 {
@@ -633,4 +628,8 @@
 	num-cs = <1>;
 };
 
+&usbdrd_phy {
+	vbus-supply = <&usb3_vbus_reg>;
+};
+
 #include "cros-ec-keyboard.dtsi"
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 834fb5a5306f..ff1c09607631 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -224,7 +224,7 @@
 		clock-names = "mfc";
 	};
 
-	rtc@101E0000 {
+	rtc: rtc@101E0000 {
 		clocks = <&clock CLK_RTC>;
 		clock-names = "rtc";
 		status = "disabled";
@@ -238,22 +238,22 @@
 		clock-names = "tmu_apbif";
 	};
 
-	serial@12C00000 {
+	uart0: serial@12C00000 {
 		clocks = <&clock CLK_UART0>, <&clock CLK_SCLK_UART0>;
 		clock-names = "uart", "clk_uart_baud0";
 	};
 
-	serial@12C10000 {
+	uart1: serial@12C10000 {
 		clocks = <&clock CLK_UART1>, <&clock CLK_SCLK_UART1>;
 		clock-names = "uart", "clk_uart_baud0";
 	};
 
-	serial@12C20000 {
+	uart2: serial@12C20000 {
 		clocks = <&clock CLK_UART2>, <&clock CLK_SCLK_UART2>;
 		clock-names = "uart", "clk_uart_baud0";
 	};
 
-	serial@12C30000 {
+	uart3: serial@12C30000 {
 		clocks = <&clock CLK_UART3>, <&clock CLK_SCLK_UART3>;
 		clock-names = "uart", "clk_uart_baud0";
 	};
@@ -570,7 +570,7 @@
 		#phy-cells = <1>;
 	};
 
-	usb@12110000 {
+	ehci: usb@12110000 {
 		compatible = "samsung,exynos4210-ehci";
 		reg = <0x12110000 0x100>;
 		interrupts = <0 71 0>;
@@ -585,7 +585,7 @@
 		};
 	};
 
-	usb@12120000 {
+	ohci: usb@12120000 {
 		compatible = "samsung,exynos4210-ohci";
 		reg = <0x12120000 0x100>;
 		interrupts = <0 71 0>;
@@ -722,7 +722,7 @@
 		clock-names = "gscl";
 	};
 
-	hdmi {
+	hdmi: hdmi {
 		compatible = "samsung,exynos4212-hdmi";
 		reg = <0x14530000 0x70000>;
 		interrupts = <0 95 0>;
@@ -748,14 +748,14 @@
 		#phy-cells = <0>;
 	};
 
-	dp-controller@145B0000 {
+	dp: dp-controller@145B0000 {
 		clocks = <&clock CLK_DP>;
 		clock-names = "dp";
 		phys = <&dp_phy>;
 		phy-names = "dp";
 	};
 
-	fimd@14400000 {
+	fimd: fimd@14400000 {
 		clocks = <&clock CLK_SCLK_FIMD1>, <&clock CLK_FIMD1>;
 		clock-names = "sclk_fimd", "fimd";
 	};
-- 
1.9.3

