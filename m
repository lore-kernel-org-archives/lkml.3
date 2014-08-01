Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaHAE5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 00:57:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbaHAE5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 00:57:00 -0400
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
Subject: [PATCH v5 06/10] ARM: dts: Clean up exynos5250-smdk5250
Date: Fri,  1 Aug 2014 06:54:53 +0200
Message-Id: <1406868897-26874-7-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406868897-26874-1-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new style for referencing inherited nodes and use symbolic names.

Goal is the alignment of all exynos5250 based device trees for comparison.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v5: New
 Follow-up after adding dp_hpd pinctrl node new-style.

 arch/arm/boot/dts/exynos5250-smdk5250.dts | 640 +++++++++++++++---------------
 arch/arm/boot/dts/exynos5250.dtsi         |   4 +-
 2 files changed, 324 insertions(+), 320 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 5d30fe1dcda4..81dc921a5e5e 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -7,9 +7,11 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
-*/
+ */
 
 /dts-v1/;
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
 #include "exynos5250.dtsi"
 
 / {
@@ -27,165 +29,6 @@
 		bootargs = "root=/dev/ram0 rw ramdisk=8192 initrd=0x41000000,8M console=ttySAC2,115200 init=/linuxrc";
 	};
 
-	rtc@101E0000 {
-		status = "okay";
-	};
-
-	i2c@12C60000 {
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <20000>;
-		status = "okay";
-
-		eeprom@50 {
-			compatible = "samsung,s524ad0xd1";
-			reg = <0x50>;
-		};
-
-		max77686@09 {
-			compatible = "maxim,max77686";
-			reg = <0x09>;
-			interrupt-parent = <&gpx3>;
-			interrupts = <2 0>;
-
-			voltage-regulators {
-				ldo1_reg: LDO1 {
-					regulator-name = "P1.0V_LDO_OUT1";
-					regulator-min-microvolt = <1000000>;
-					regulator-max-microvolt = <1000000>;
-					regulator-always-on;
-				};
-
-				ldo2_reg: LDO2 {
-					regulator-name = "P1.2V_LDO_OUT2";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <1200000>;
-					regulator-always-on;
-				};
-
-				ldo3_reg: LDO3 {
-					regulator-name = "P1.8V_LDO_OUT3";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-				};
-
-				ldo4_reg: LDO4 {
-					regulator-name = "P2.8V_LDO_OUT4";
-					regulator-min-microvolt = <2800000>;
-					regulator-max-microvolt = <2800000>;
-				};
-
-				ldo5_reg: LDO5 {
-					regulator-name = "P1.8V_LDO_OUT5";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				ldo6_reg: LDO6 {
-					regulator-name = "P1.1V_LDO_OUT6";
-					regulator-min-microvolt = <1100000>;
-					regulator-max-microvolt = <1100000>;
-					regulator-always-on;
-				};
-
-				ldo7_reg: LDO7 {
-					regulator-name = "P1.1V_LDO_OUT7";
-					regulator-min-microvolt = <1100000>;
-					regulator-max-microvolt = <1100000>;
-					regulator-always-on;
-				};
-
-				ldo8_reg: LDO8 {
-					regulator-name = "P1.0V_LDO_OUT8";
-					regulator-min-microvolt = <1000000>;
-					regulator-max-microvolt = <1000000>;
-				};
-
-				ldo10_reg: LDO10 {
-					regulator-name = "P1.8V_LDO_OUT10";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				ldo11_reg: LDO11 {
-					regulator-name = "P1.8V_LDO_OUT11";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				ldo12_reg: LDO12 {
-					regulator-name = "P3.0V_LDO_OUT12";
-					regulator-min-microvolt = <3000000>;
-					regulator-max-microvolt = <3000000>;
-				};
-
-				ldo13_reg: LDO13 {
-					regulator-name = "P1.8V_LDO_OUT13";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				ldo14_reg: LDO14 {
-					regulator-name = "P1.8V_LDO_OUT14";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				ldo15_reg: LDO15 {
-					regulator-name = "P1.0V_LDO_OUT15";
-					regulator-min-microvolt = <1000000>;
-					regulator-max-microvolt = <1000000>;
-				};
-
-				ldo16_reg: LDO16 {
-					regulator-name = "P1.8V_LDO_OUT16";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-				};
-
-				buck1_reg: BUCK1 {
-					regulator-name = "vdd_mif";
-					regulator-min-microvolt = <950000>;
-					regulator-max-microvolt = <1300000>;
-					regulator-always-on;
-					regulator-boot-on;
-				};
-
-				buck2_reg: BUCK2 {
-					regulator-name = "vdd_arm";
-					regulator-min-microvolt = <850000>;
-					regulator-max-microvolt = <1350000>;
-					regulator-always-on;
-					regulator-boot-on;
-				};
-
-				buck3_reg: BUCK3 {
-					regulator-name = "vdd_int";
-					regulator-min-microvolt = <900000>;
-					regulator-max-microvolt = <1200000>;
-					regulator-always-on;
-					regulator-boot-on;
-				};
-
-				buck4_reg: BUCK4 {
-					regulator-name = "vdd_g3d";
-					regulator-min-microvolt = <850000>;
-					regulator-max-microvolt = <1300000>;
-					regulator-always-on;
-					regulator-boot-on;
-				};
-
-				buck5_reg: BUCK5 {
-					regulator-name = "P1.8V_BUCK_OUT5";
-					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <1800000>;
-					regulator-always-on;
-					regulator-boot-on;
-				};
-			};
-		};
-	};
-
 	vdd: fixed-regulator@0 {
 		compatible = "regulator-fixed";
 		regulator-name = "vdd-supply";
@@ -210,208 +53,328 @@
 		regulator-always-on;
 	};
 
-	i2c@12C70000 {
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <20000>;
-		status = "okay";
+	sound {
+		compatible = "samsung,smdk-wm8994";
+
+		samsung,i2s-controller = <&i2s0>;
+		samsung,audio-codec = <&wm8994>;
+	};
 
-		eeprom@51 {
-			compatible = "samsung,s524ad0xd1";
-			reg = <0x51>;
+	fixed-rate-clocks {
+		xxti {
+			compatible = "samsung,clock-xxti";
+			clock-frequency = <24000000>;
+		};
+
+		codec_mclk: codec-mclk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <16934000>;
 		};
+	};
+};
 
-		wm8994: wm8994@1a {
-			compatible = "wlf,wm8994";
-			reg = <0x1a>;
+&codec {
+	samsung,mfc-r = <0x43000000 0x800000>;
+	samsung,mfc-l = <0x51000000 0x800000>;
+};
 
-			gpio-controller;
-			#gpio-cells = <2>;
+&dp {
+	samsung,color-space = <0>;
+	samsung,dynamic-range = <0>;
+	samsung,ycbcr-coeff = <0>;
+	samsung,color-depth = <1>;
+	samsung,link-rate = <0x0a>;
+	samsung,lane-count = <4>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&dp_hpd>;
+	status = "okay";
+};
 
-			clocks = <&codec_mclk>;
-			clock-names = "MCLK1";
+&ehci {
+	samsung,vbus-gpio = <&gpx2 6 GPIO_ACTIVE_HIGH>;
+};
 
-			AVDD2-supply = <&vdd>;
-			CPVDD-supply = <&vdd>;
-			DBVDD-supply = <&dbvdd>;
-			SPKVDD1-supply = <&spkvdd>;
-			SPKVDD2-supply = <&spkvdd>;
+&fimd {
+	status = "okay";
+
+	display-timings {
+		native-mode = <&timing0>;
+
+		timing0: timing@0 {
+			/* 1280x800 */
+			clock-frequency = <50000>;
+			hactive = <1280>;
+			vactive = <800>;
+			hfront-porch = <4>;
+			hback-porch = <4>;
+			hsync-len = <4>;
+			vback-porch = <4>;
+			vfront-porch = <4>;
+			vsync-len = <4>;
 		};
 	};
+};
 
-	i2c@121D0000 {
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <40000>;
-		samsung,i2c-slave-addr = <0x38>;
-		status = "okay";
+&hdmi {
+	hpd-gpio = <&gpx3 7 GPIO_ACTIVE_HIGH>;
+};
 
-		sata_phy_i2c:sata-phy@38 {
-			compatible = "samsung,exynos-sataphy-i2c";
-			reg = <0x38>;
-		};
+&i2c_0 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <20000>;
+
+	eeprom@50 {
+		compatible = "samsung,s524ad0xd1";
+		reg = <0x50>;
 	};
 
-	i2c@12C80000 {
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <66000>;
-		status = "okay";
+	max77686@09 {
+		compatible = "maxim,max77686";
+		reg = <0x09>;
+		interrupt-parent = <&gpx3>;
+		interrupts = <2 IRQ_TYPE_NONE>;
+
+		voltage-regulators {
+			ldo1_reg: LDO1 {
+				regulator-name = "P1.0V_LDO_OUT1";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
 
-		hdmiddc@50 {
-			compatible = "samsung,exynos4210-hdmiddc";
-			reg = <0x50>;
-		};
-	};
+			ldo2_reg: LDO2 {
+				regulator-name = "P1.2V_LDO_OUT2";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+			};
 
-	i2c@12CE0000 {
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <66000>;
-		status = "okay";
+			ldo3_reg: LDO3 {
+				regulator-name = "P1.8V_LDO_OUT3";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
 
-		hdmiphy@38 {
-			compatible = "samsung,exynos4212-hdmiphy";
-			reg = <0x38>;
-		};
-	};
+			ldo4_reg: LDO4 {
+				regulator-name = "P2.8V_LDO_OUT4";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+			};
 
-	sata@122F0000 {
-		status = "okay";
-	};
+			ldo5_reg: LDO5 {
+				regulator-name = "P1.8V_LDO_OUT5";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
 
-	sata-phy@12170000 {
-		status = "okay";
-		samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
-	};
+			ldo6_reg: LDO6 {
+				regulator-name = "P1.1V_LDO_OUT6";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
+				regulator-always-on;
+			};
 
-	mmc@12200000 {
-		status = "okay";
-		num-slots = <1>;
-		supports-highspeed;
-		broken-cd;
-		card-detect-delay = <200>;
-		samsung,dw-mshc-ciu-div = <3>;
-		samsung,dw-mshc-sdr-timing = <2 3>;
-		samsung,dw-mshc-ddr-timing = <1 2>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_bus4 &sd0_bus8>;
-
-		slot@0 {
-			reg = <0>;
-			bus-width = <8>;
-		};
-	};
+			ldo7_reg: LDO7 {
+				regulator-name = "P1.1V_LDO_OUT7";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
+				regulator-always-on;
+			};
 
-	mmc@12220000 {
-		status = "okay";
-		num-slots = <1>;
-		supports-highspeed;
-		card-detect-delay = <200>;
-		samsung,dw-mshc-ciu-div = <3>;
-		samsung,dw-mshc-sdr-timing = <2 3>;
-		samsung,dw-mshc-ddr-timing = <1 2>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
-
-		slot@0 {
-			reg = <0>;
-			bus-width = <4>;
-			disable-wp;
-		};
-	};
+			ldo8_reg: LDO8 {
+				regulator-name = "P1.0V_LDO_OUT8";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+			};
+
+			ldo10_reg: LDO10 {
+				regulator-name = "P1.8V_LDO_OUT10";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
 
-	spi_1: spi@12d30000 {
-		status = "okay";
+			ldo11_reg: LDO11 {
+				regulator-name = "P1.8V_LDO_OUT11";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
 
-		w25q80bw@0 {
-			#address-cells = <1>;
-			#size-cells = <1>;
-			compatible = "w25x80";
-			reg = <0>;
-			spi-max-frequency = <1000000>;
+			ldo12_reg: LDO12 {
+				regulator-name = "P3.0V_LDO_OUT12";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+			};
+
+			ldo13_reg: LDO13 {
+				regulator-name = "P1.8V_LDO_OUT13";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
 
-			controller-data {
-				cs-gpio = <&gpa2 5 0>;
-				samsung,spi-feedback-delay = <0>;
+			ldo14_reg: LDO14 {
+				regulator-name = "P1.8V_LDO_OUT14";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 			};
 
-			partition@0 {
-				label = "U-Boot";
-				reg = <0x0 0x40000>;
-				read-only;
+			ldo15_reg: LDO15 {
+				regulator-name = "P1.0V_LDO_OUT15";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
 			};
 
-			partition@40000 {
-				label = "Kernel";
-				reg = <0x40000 0xc0000>;
+			ldo16_reg: LDO16 {
+				regulator-name = "P1.8V_LDO_OUT16";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			buck1_reg: BUCK1 {
+				regulator-name = "vdd_mif";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck2_reg: BUCK2 {
+				regulator-name = "vdd_arm";
+				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck3_reg: BUCK3 {
+				regulator-name = "vdd_int";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck4_reg: BUCK4 {
+				regulator-name = "vdd_g3d";
+				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck5_reg: BUCK5 {
+				regulator-name = "P1.8V_BUCK_OUT5";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
 			};
 		};
 	};
+};
 
-	hdmi {
-		hpd-gpio = <&gpx3 7 0>;
-	};
+&i2c_1 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <20000>;
 
-	codec@11000000 {
-		samsung,mfc-r = <0x43000000 0x800000>;
-		samsung,mfc-l = <0x51000000 0x800000>;
+	eeprom@51 {
+		compatible = "samsung,s524ad0xd1";
+		reg = <0x51>;
 	};
 
-	i2s0: i2s@03830000 {
-		status = "okay";
-	};
+	wm8994: wm8994@1a {
+		compatible = "wlf,wm8994";
+		reg = <0x1a>;
 
-	sound {
-		compatible = "samsung,smdk-wm8994";
+		gpio-controller;
+		#gpio-cells = <2>;
 
-		samsung,i2s-controller = <&i2s0>;
-		samsung,audio-codec = <&wm8994>;
+		clocks = <&codec_mclk>;
+		clock-names = "MCLK1";
+
+		AVDD2-supply = <&vdd>;
+		CPVDD-supply = <&vdd>;
+		DBVDD-supply = <&dbvdd>;
+		SPKVDD1-supply = <&spkvdd>;
+		SPKVDD2-supply = <&spkvdd>;
 	};
+};
 
-	usb@12110000 {
-		samsung,vbus-gpio = <&gpx2 6 0>;
+&i2c_2 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <66000>;
+
+	hdmiddc@50 {
+		compatible = "samsung,exynos4210-hdmiddc";
+		reg = <0x50>;
 	};
+};
+
+&i2c_8 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <66000>;
 
-	dp-controller@145B0000 {
-		samsung,color-space = <0>;
-		samsung,dynamic-range = <0>;
-		samsung,ycbcr-coeff = <0>;
-		samsung,color-depth = <1>;
-		samsung,link-rate = <0x0a>;
-		samsung,lane-count = <4>;
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&dp_hpd>;
-		status = "okay";
+	hdmiphy@38 {
+		compatible = "samsung,exynos4212-hdmiphy";
+		reg = <0x38>;
 	};
+};
 
-	fimd@14400000 {
-		status = "okay";
-		display-timings {
-			native-mode = <&timing0>;
-			timing0: timing@0 {
-				/* 1280x800 */
-				clock-frequency = <50000>;
-				hactive = <1280>;
-				vactive = <800>;
-				hfront-porch = <4>;
-				hback-porch = <4>;
-				hsync-len = <4>;
-				vback-porch = <4>;
-				vfront-porch = <4>;
-				vsync-len = <4>;
-			};
-		};
+&i2c_9 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <40000>;
+	samsung,i2c-slave-addr = <0x38>;
+
+	sata_phy_i2c: sata-phy@38 {
+		compatible = "samsung,exynos-sataphy-i2c";
+		reg = <0x38>;
 	};
+};
 
-	fixed-rate-clocks {
-		xxti {
-			compatible = "samsung,clock-xxti";
-			clock-frequency = <24000000>;
-		};
+&i2s0 {
+	status = "okay";
+};
 
-		codec_mclk: codec-mclk {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <16934000>;
-		};
+&mmc_0 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	broken-cd;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_bus4 &sd0_bus8>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <8>;
+	};
+};
+
+&mmc_2 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <4>;
+		disable-wp;
 	};
 };
 
@@ -423,3 +386,44 @@
 		samsung,pin-drv = <0>;
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
+
+&spi_1 {
+	status = "okay";
+
+	w25q80bw@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "w25x80";
+		reg = <0>;
+		spi-max-frequency = <1000000>;
+
+		controller-data {
+			cs-gpio = <&gpa2 5 GPIO_ACTIVE_HIGH>;
+			samsung,spi-feedback-delay = <0>;
+		};
+
+		partition@0 {
+			label = "U-Boot";
+			reg = <0x0 0x40000>;
+			read-only;
+		};
+
+		partition@40000 {
+			label = "Kernel";
+			reg = <0x40000 0xc0000>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index ff1c09607631..30482fc523f9 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -215,7 +215,7 @@
 		clock-names = "fimg2d";
 	};
 
-	codec@11000000 {
+	codec: codec@11000000 {
 		compatible = "samsung,mfc-v6";
 		reg = <0x11000000 0x10000>;
 		interrupts = <0 96 0>;
@@ -258,7 +258,7 @@
 		clock-names = "uart", "clk_uart_baud0";
 	};
 
-	sata@122F0000 {
+	sata: sata@122F0000 {
 		compatible = "snps,dwc-ahci";
 		samsung,sata-freq = <66>;
 		reg = <0x122F0000 0x1ff>;
-- 
1.9.3

