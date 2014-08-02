Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaHBAy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 20:54:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbaHBAxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 20:53:19 -0400
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
Subject: [PATCH v6 07/10] ARM: dts: Clean up exynos5250-arndale
Date: Sat,  2 Aug 2014 02:52:27 +0200
Message-Id: <1406940750-15880-8-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406940750-15880-1-git-send-email-afaerber@suse.de>
References: <1406940750-15880-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new style of referencing inherited nodes, use symbolic names,
tidy indentation and reorder includes.

Goal is the alignment of all exynos5250 based device trees for comparison.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v5 -> v6:
 * Updated for mfc node label
 
 v5: New
 Aligns with SMDK.

 arch/arm/boot/dts/exynos5250-arndale.dts | 929 ++++++++++++++++---------------
 1 file changed, 466 insertions(+), 463 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index d0de1f50d15b..aac41c394d43 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -7,12 +7,13 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
-*/
+ */
 
 /dts-v1/;
-#include "exynos5250.dtsi"
+#include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
+#include "exynos5250.dtsi"
 
 / {
 	model = "Insignal Arndale evaluation board based on EXYNOS5250";
@@ -26,473 +27,52 @@
 		bootargs = "console=ttySAC2,115200";
 	};
 
-	rtc@101E0000 {
-		status = "okay";
-	};
-
-	codec@11000000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
-	};
-
-	i2c@12C60000 {
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <20000>;
-		samsung,i2c-slave-addr = <0x66>;
-		status = "okay";
-
-		s5m8767_pmic@66 {
-			compatible = "samsung,s5m8767-pmic";
-			reg = <0x66>;
-			interrupt-parent = <&gpx3>;
-			interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
-
-			vinb1-supply = <&main_dc_reg>;
-			vinb2-supply = <&main_dc_reg>;
-			vinb3-supply = <&main_dc_reg>;
-			vinb4-supply = <&main_dc_reg>;
-			vinb5-supply = <&main_dc_reg>;
-			vinb6-supply = <&main_dc_reg>;
-			vinb7-supply = <&main_dc_reg>;
-			vinb8-supply = <&main_dc_reg>;
-			vinb9-supply = <&main_dc_reg>;
-
-			vinl1-supply = <&buck7_reg>;
-			vinl2-supply = <&buck7_reg>;
-			vinl3-supply = <&buck7_reg>;
-			vinl4-supply = <&main_dc_reg>;
-			vinl5-supply = <&main_dc_reg>;
-			vinl6-supply = <&main_dc_reg>;
-			vinl7-supply = <&main_dc_reg>;
-			vinl8-supply = <&buck8_reg>;
-			vinl9-supply = <&buck8_reg>;
-
-			s5m8767,pmic-buck2-dvs-voltage = <1300000>;
-			s5m8767,pmic-buck3-dvs-voltage = <1100000>;
-			s5m8767,pmic-buck4-dvs-voltage = <1200000>;
-			s5m8767,pmic-buck-dvs-gpios = <&gpd1 0 0>,
-							<&gpd1 1 0>,
-							<&gpd1 2 0>;
-			s5m8767,pmic-buck-ds-gpios = <&gpx2 3 0>,
-							<&gpx2 4 0>,
-							<&gpx2 5 0>;
-			regulators {
-				ldo1_reg: LDO1 {
-					regulator-name = "VDD_ALIVE_1.0V";
-					regulator-min-microvolt = <1100000>;
-					regulator-max-microvolt = <1100000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo2_reg: LDO2 {
-					regulator-name = "VDD_28IO_DP_1.35V";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <1200000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo3_reg: LDO3 {
-					regulator-name = "VDD_COMMON1_1.8V";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo4_reg: LDO4 {
-					regulator-name = "VDD_IOPERI_1.8V";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-					op_mode = <1>;
-				};
-
-				ldo5_reg: LDO5 {
-					regulator-name = "VDD_EXT_1.8V";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo6_reg: LDO6 {
-					regulator-name = "VDD_MPLL_1.1V";
-					regulator-min-microvolt = <1100000>;
-					regulator-max-microvolt = <1100000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo7_reg: LDO7 {
-					regulator-name = "VDD_XPLL_1.1V";
-					regulator-min-microvolt = <1100000>;
-					regulator-max-microvolt = <1100000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo8_reg: LDO8 {
-					regulator-name = "VDD_COMMON2_1.0V";
-					regulator-min-microvolt = <1000000>;
-					regulator-max-microvolt = <1000000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo9_reg: LDO9 {
-					regulator-name = "VDD_33ON_3.0V";
-					regulator-min-microvolt = <3000000>;
-					regulator-max-microvolt = <3000000>;
-					op_mode = <1>;
-				};
-
-				ldo10_reg: LDO10 {
-					regulator-name = "VDD_COMMON3_1.8V";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo11_reg: LDO11 {
-					regulator-name = "VDD_ABB2_1.8V";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo12_reg: LDO12 {
-					regulator-name = "VDD_USB_3.0V";
-					regulator-min-microvolt = <3000000>;
-					regulator-max-microvolt = <3000000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo13_reg: LDO13 {
-					regulator-name = "VDDQ_C2C_W_1.8V";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo14_reg: LDO14 {
-					regulator-name = "VDD18_ABB0_3_1.8V";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo15_reg: LDO15 {
-					regulator-name = "VDD10_COMMON4_1.0V";
-					regulator-min-microvolt = <1000000>;
-					regulator-max-microvolt = <1000000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo16_reg: LDO16 {
-					regulator-name = "VDD18_HSIC_1.8V";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo17_reg: LDO17 {
-					regulator-name = "VDDQ_MMC2_3_2.8V";
-					regulator-min-microvolt = <2800000>;
-					regulator-max-microvolt = <2800000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				ldo18_reg: LDO18 {
-					regulator-name = "VDD_33ON_2.8V";
-					regulator-min-microvolt = <2800000>;
-					regulator-max-microvolt = <2800000>;
-					op_mode = <1>;
-				};
-
-				ldo22_reg: LDO22 {
-					regulator-name = "EXT_33_OFF";
-					regulator-min-microvolt = <3300000>;
-					regulator-max-microvolt = <3300000>;
-					op_mode = <1>;
-				};
-
-				ldo23_reg: LDO23 {
-					regulator-name = "EXT_28_OFF";
-					regulator-min-microvolt = <2800000>;
-					regulator-max-microvolt = <2800000>;
-					op_mode = <1>;
-				};
-
-				ldo25_reg: LDO25 {
-					regulator-name = "PVDD_LDO25";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <1200000>;
-					op_mode = <1>;
-				};
-
-				ldo26_reg: LDO26 {
-					regulator-name = "EXT_18_OFF";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					op_mode = <1>;
-				};
-
-				buck1_reg: BUCK1 {
-					regulator-name = "vdd_mif";
-					regulator-min-microvolt = <950000>;
-					regulator-max-microvolt = <1200000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				buck2_reg: BUCK2 {
-					regulator-name = "vdd_arm";
-					regulator-min-microvolt = <912500>;
-					regulator-max-microvolt = <1300000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				buck3_reg: BUCK3 {
-					regulator-name = "vdd_int";
-					regulator-min-microvolt = <900000>;
-					regulator-max-microvolt = <1200000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				buck4_reg: BUCK4 {
-					regulator-name = "vdd_g3d";
-					regulator-min-microvolt = <1000000>;
-					regulator-max-microvolt = <1000000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				buck5_reg: BUCK5 {
-					regulator-name = "VDD_MEM_1.35V";
-					regulator-min-microvolt = <750000>;
-					regulator-max-microvolt = <1355000>;
-					regulator-always-on;
-					regulator-boot-on;
-					op_mode = <1>;
-				};
-
-				buck7_reg: BUCK7 {
-					regulator-name = "PVDD_BUCK7";
-					regulator-always-on;
-					op_mode = <1>;
-				};
-
-				buck8_reg: BUCK8 {
-					regulator-name = "PVDD_BUCK8";
-					regulator-always-on;
-					op_mode = <1>;
-				};
-
-				buck9_reg: BUCK9 {
-					regulator-name = "VDD_33_OFF_EXT1";
-					regulator-min-microvolt = <750000>;
-					regulator-max-microvolt = <3000000>;
-					op_mode = <1>;
-				};
-			};
-		};
-	};
-
-	i2c@12C80000 {
-		status = "okay";
-
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <66000>;
-		samsung,i2c-slave-addr = <0x50>;
-
-		hdmiddc@50 {
-			compatible = "samsung,exynos4210-hdmiddc";
-			reg = <0x50>;
-		};
-	};
-
-	i2c@12C90000 {
-		status = "okay";
-
-		wm1811a@1a {
-
-			compatible = "wlf,wm1811";
-			reg = <0x1a>;
-
-			AVDD2-supply = <&main_dc_reg>;
-			CPVDD-supply = <&main_dc_reg>;
-			DBVDD1-supply = <&main_dc_reg>;
-			DBVDD2-supply = <&main_dc_reg>;
-			DBVDD3-supply = <&main_dc_reg>;
-			LDO1VDD-supply = <&main_dc_reg>;
-			SPKVDD1-supply = <&main_dc_reg>;
-			SPKVDD2-supply = <&main_dc_reg>;
-
-			wlf,ldo1ena = <&gpb0 0 0>;
-			wlf,ldo2ena = <&gpb0 1 0>;
-		};
-	};
-
-	i2c@12CE0000 {
-		status = "okay";
-
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <66000>;
-		samsung,i2c-slave-addr = <0x38>;
-
-		hdmiphy@38 {
-			compatible = "samsung,exynos4212-hdmiphy";
-			reg = <0x38>;
-		};
-	};
-
-	i2c@121D0000 {
-		status = "okay";
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <40000>;
-		samsung,i2c-slave-addr = <0x38>;
-
-		sata_phy_i2c:sata-phy@38 {
-			compatible = "samsung,exynos-sataphy-i2c";
-			reg = <0x38>;
-		};
-	};
-
-	sata@122F0000 {
-		status = "okay";
-	};
-
-	sata-phy@12170000 {
-		status = "okay";
-		samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
-	};
-
-	mmc_0: mmc@12200000 {
-		status = "okay";
-		num-slots = <1>;
-		supports-highspeed;
-		broken-cd;
-		card-detect-delay = <200>;
-		samsung,dw-mshc-ciu-div = <3>;
-		samsung,dw-mshc-sdr-timing = <2 3>;
-		samsung,dw-mshc-ddr-timing = <1 2>;
-		vmmc-supply = <&mmc_reg>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_bus4 &sd0_bus8>;
-
-		slot@0 {
-			reg = <0>;
-			bus-width = <8>;
-		};
-	};
-
-	mmc_2: mmc@12220000 {
-		status = "okay";
-		num-slots = <1>;
-		supports-highspeed;
-		card-detect-delay = <200>;
-		samsung,dw-mshc-ciu-div = <3>;
-		samsung,dw-mshc-sdr-timing = <2 3>;
-		samsung,dw-mshc-ddr-timing = <1 2>;
-		vmmc-supply = <&mmc_reg>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
-
-		slot@0 {
-			reg = <0>;
-			bus-width = <4>;
-			disable-wp;
-		};
-	};
-
-	i2s0: i2s@03830000 {
-		status = "okay";
-	};
-
 	gpio_keys {
 		compatible = "gpio-keys";
 
 		menu {
 			label = "SW-TACT2";
-			gpios = <&gpx1 4 1>;
+			gpios = <&gpx1 4 GPIO_ACTIVE_LOW>;
 			linux,code = <KEY_MENU>;
 			gpio-key,wakeup;
 		};
 
 		home {
 			label = "SW-TACT3";
-			gpios = <&gpx1 5 1>;
+			gpios = <&gpx1 5 GPIO_ACTIVE_LOW>;
 			linux,code = <KEY_HOME>;
 			gpio-key,wakeup;
 		};
 
 		up {
 			label = "SW-TACT4";
-			gpios = <&gpx1 6 1>;
+			gpios = <&gpx1 6 GPIO_ACTIVE_LOW>;
 			linux,code = <KEY_UP>;
 			gpio-key,wakeup;
 		};
 
 		down {
 			label = "SW-TACT5";
-			gpios = <&gpx1 7 1>;
+			gpios = <&gpx1 7 GPIO_ACTIVE_LOW>;
 			linux,code = <KEY_DOWN>;
 			gpio-key,wakeup;
 		};
 
 		back {
 			label = "SW-TACT6";
-			gpios = <&gpx2 0 1>;
+			gpios = <&gpx2 0 GPIO_ACTIVE_LOW>;
 			linux,code = <KEY_BACK>;
 			gpio-key,wakeup;
 		};
 
 		wakeup {
 			label = "SW-TACT7";
-			gpios = <&gpx2 1 1>;
+			gpios = <&gpx2 1 GPIO_ACTIVE_LOW>;
 			linux,code = <KEY_WAKEUP>;
 			gpio-key,wakeup;
 		};
 	};
 
-	hdmi {
-		hpd-gpio = <&gpx3 7 2>;
-		vdd_osc-supply = <&ldo10_reg>;
-		vdd_pll-supply = <&ldo8_reg>;
-		vdd-supply = <&ldo8_reg>;
-	};
-
 	regulators {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -510,7 +90,7 @@
 			regulator-name = "VDD_33ON_2.8V";
 			regulator-min-microvolt = <2800000>;
 			regulator-max-microvolt = <2800000>;
-			gpio = <&gpx1 1 1>;
+			gpio = <&gpx1 1 GPIO_ACTIVE_LOW>;
 			enable-active-high;
 		};
 
@@ -528,35 +108,6 @@
 		};
 	};
 
-	dp-controller@145B0000 {
-		samsung,color-space = <0>;
-		samsung,dynamic-range = <0>;
-		samsung,ycbcr-coeff = <0>;
-		samsung,color-depth = <1>;
-		samsung,link-rate = <0x0a>;
-		samsung,lane-count = <4>;
-		status = "okay";
-	};
-
-	fimd: fimd@14400000 {
-		status = "okay";
-		display-timings {
-			native-mode = <&timing0>;
-			timing0: timing@0 {
-				/* 2560x1600 DP panel */
-				clock-frequency = <50000>;
-				hactive = <2560>;
-				vactive = <1600>;
-				hfront-porch = <48>;
-				hback-porch = <80>;
-				hsync-len = <32>;
-				vback-porch = <16>;
-				vfront-porch = <8>;
-				vsync-len = <6>;
-			};
-		};
-	};
-
 	usb_hub_bus {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -566,12 +117,464 @@
 		usb_hub: usb_hub {
 			compatible = "smsc,usb3503a";
 
-			reset-gpios = <&gpx3 5 1>;
-			connect-gpios = <&gpd1 7 1>;
+			reset-gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
+			connect-gpios = <&gpd1 7 GPIO_ACTIVE_LOW>;
+		};
+	};
+};
+
+&dp {
+	status = "okay";
+	samsung,color-space = <0>;
+	samsung,dynamic-range = <0>;
+	samsung,ycbcr-coeff = <0>;
+	samsung,color-depth = <1>;
+	samsung,link-rate = <0x0a>;
+	samsung,lane-count = <4>;
+};
+
+&ehci {
+	usb-phy = <&usb2_phy>;
+};
+
+&fimd {
+	status = "okay";
+
+	display-timings {
+		native-mode = <&timing0>;
+
+		timing0: timing@0 {
+			/* 2560x1600 DP panel */
+			clock-frequency = <50000>;
+			hactive = <2560>;
+			vactive = <1600>;
+			hfront-porch = <48>;
+			hback-porch = <80>;
+			hsync-len = <32>;
+			vback-porch = <16>;
+			vfront-porch = <8>;
+			vsync-len = <6>;
+		};
+	};
+};
+
+&hdmi {
+	hpd-gpio = <&gpx3 7 2>;
+	vdd_osc-supply = <&ldo10_reg>;
+	vdd_pll-supply = <&ldo8_reg>;
+	vdd-supply = <&ldo8_reg>;
+};
+
+&i2c_0 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <20000>;
+	samsung,i2c-slave-addr = <0x66>;
+
+	s5m8767_pmic@66 {
+		compatible = "samsung,s5m8767-pmic";
+		reg = <0x66>;
+		interrupt-parent = <&gpx3>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
+
+		vinb1-supply = <&main_dc_reg>;
+		vinb2-supply = <&main_dc_reg>;
+		vinb3-supply = <&main_dc_reg>;
+		vinb4-supply = <&main_dc_reg>;
+		vinb5-supply = <&main_dc_reg>;
+		vinb6-supply = <&main_dc_reg>;
+		vinb7-supply = <&main_dc_reg>;
+		vinb8-supply = <&main_dc_reg>;
+		vinb9-supply = <&main_dc_reg>;
+
+		vinl1-supply = <&buck7_reg>;
+		vinl2-supply = <&buck7_reg>;
+		vinl3-supply = <&buck7_reg>;
+		vinl4-supply = <&main_dc_reg>;
+		vinl5-supply = <&main_dc_reg>;
+		vinl6-supply = <&main_dc_reg>;
+		vinl7-supply = <&main_dc_reg>;
+		vinl8-supply = <&buck8_reg>;
+		vinl9-supply = <&buck8_reg>;
+
+		s5m8767,pmic-buck2-dvs-voltage = <1300000>;
+		s5m8767,pmic-buck3-dvs-voltage = <1100000>;
+		s5m8767,pmic-buck4-dvs-voltage = <1200000>;
+		s5m8767,pmic-buck-dvs-gpios = <&gpd1 0 GPIO_ACTIVE_HIGH>,
+		                              <&gpd1 1 GPIO_ACTIVE_HIGH>,
+		                              <&gpd1 2 GPIO_ACTIVE_HIGH>;
+		s5m8767,pmic-buck-ds-gpios = <&gpx2 3 GPIO_ACTIVE_HIGH>,
+		                             <&gpx2 4 GPIO_ACTIVE_HIGH>,
+		                             <&gpx2 5 GPIO_ACTIVE_HIGH>;
+
+		regulators {
+			ldo1_reg: LDO1 {
+				regulator-name = "VDD_ALIVE_1.0V";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo2_reg: LDO2 {
+				regulator-name = "VDD_28IO_DP_1.35V";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo3_reg: LDO3 {
+				regulator-name = "VDD_COMMON1_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo4_reg: LDO4 {
+				regulator-name = "VDD_IOPERI_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				op_mode = <1>;
+			};
+
+			ldo5_reg: LDO5 {
+				regulator-name = "VDD_EXT_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo6_reg: LDO6 {
+				regulator-name = "VDD_MPLL_1.1V";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo7_reg: LDO7 {
+				regulator-name = "VDD_XPLL_1.1V";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo8_reg: LDO8 {
+				regulator-name = "VDD_COMMON2_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo9_reg: LDO9 {
+				regulator-name = "VDD_33ON_3.0V";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+				op_mode = <1>;
+			};
+
+			ldo10_reg: LDO10 {
+				regulator-name = "VDD_COMMON3_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo11_reg: LDO11 {
+				regulator-name = "VDD_ABB2_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo12_reg: LDO12 {
+				regulator-name = "VDD_USB_3.0V";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo13_reg: LDO13 {
+				regulator-name = "VDDQ_C2C_W_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo14_reg: LDO14 {
+				regulator-name = "VDD18_ABB0_3_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo15_reg: LDO15 {
+				regulator-name = "VDD10_COMMON4_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo16_reg: LDO16 {
+				regulator-name = "VDD18_HSIC_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo17_reg: LDO17 {
+				regulator-name = "VDDQ_MMC2_3_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			ldo18_reg: LDO18 {
+				regulator-name = "VDD_33ON_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				op_mode = <1>;
+			};
+
+			ldo22_reg: LDO22 {
+				regulator-name = "EXT_33_OFF";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				op_mode = <1>;
+			};
+
+			ldo23_reg: LDO23 {
+				regulator-name = "EXT_28_OFF";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				op_mode = <1>;
+			};
+
+			ldo25_reg: LDO25 {
+				regulator-name = "PVDD_LDO25";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				op_mode = <1>;
+			};
+
+			ldo26_reg: LDO26 {
+				regulator-name = "EXT_18_OFF";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				op_mode = <1>;
+			};
+
+			buck1_reg: BUCK1 {
+				regulator-name = "vdd_mif";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			buck2_reg: BUCK2 {
+				regulator-name = "vdd_arm";
+				regulator-min-microvolt = <912500>;
+				regulator-max-microvolt = <1300000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			buck3_reg: BUCK3 {
+				regulator-name = "vdd_int";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			buck4_reg: BUCK4 {
+				regulator-name = "vdd_g3d";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			buck5_reg: BUCK5 {
+				regulator-name = "VDD_MEM_1.35V";
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <1355000>;
+				regulator-always-on;
+				regulator-boot-on;
+				op_mode = <1>;
+			};
+
+			buck7_reg: BUCK7 {
+				regulator-name = "PVDD_BUCK7";
+				regulator-always-on;
+				op_mode = <1>;
+			};
+
+			buck8_reg: BUCK8 {
+				regulator-name = "PVDD_BUCK8";
+				regulator-always-on;
+				op_mode = <1>;
+			};
+
+			buck9_reg: BUCK9 {
+				regulator-name = "VDD_33_OFF_EXT1";
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3000000>;
+				op_mode = <1>;
+			};
 		};
 	};
+};
+
+&i2c_2 {
+	status = "okay";
+
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <66000>;
+	samsung,i2c-slave-addr = <0x50>;
+
+	hdmiddc@50 {
+		compatible = "samsung,exynos4210-hdmiddc";
+		reg = <0x50>;
+	};
+};
+
+&i2c_3 {
+	status = "okay";
+
+	wm1811a@1a {
+		compatible = "wlf,wm1811";
+		reg = <0x1a>;
+
+		AVDD2-supply = <&main_dc_reg>;
+		CPVDD-supply = <&main_dc_reg>;
+		DBVDD1-supply = <&main_dc_reg>;
+		DBVDD2-supply = <&main_dc_reg>;
+		DBVDD3-supply = <&main_dc_reg>;
+		LDO1VDD-supply = <&main_dc_reg>;
+		SPKVDD1-supply = <&main_dc_reg>;
+		SPKVDD2-supply = <&main_dc_reg>;
+
+		wlf,ldo1ena = <&gpb0 0 GPIO_ACTIVE_HIGH>;
+		wlf,ldo2ena = <&gpb0 1 GPIO_ACTIVE_HIGH>;
+	};
+};
+
+&i2c_8 {
+	status = "okay";
+
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <66000>;
+	samsung,i2c-slave-addr = <0x38>;
+
+	hdmiphy@38 {
+		compatible = "samsung,exynos4212-hdmiphy";
+		reg = <0x38>;
+	};
+};
+
+&i2c_9 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <40000>;
+	samsung,i2c-slave-addr = <0x38>;
+
+	sata_phy_i2c:sata-phy@38 {
+		compatible = "samsung,exynos-sataphy-i2c";
+		reg = <0x38>;
+	};
+};
+
+&i2s0 {
+	status = "okay";
+};
+
+&mfc {
+	samsung,mfc-r = <0x43000000 0x800000>;
+	samsung,mfc-l = <0x51000000 0x800000>;
+};
+
+&mmc_0 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	broken-cd;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+	vmmc-supply = <&mmc_reg>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_bus4 &sd0_bus8>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <8>;
+	};
+};
 
-	usb@12110000 {
-		usb-phy = <&usb2_phy>;
+&mmc_2 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+	vmmc-supply = <&mmc_reg>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <4>;
+		disable-wp;
 	};
 };
+
+&rtc {
+	status = "okay";
+};
+
+&sata {
+	status = "okay";
+};
+
+&sata_phy {
+	status = "okay";
+	samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
+};
-- 
1.9.3

