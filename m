Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaFWBX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:23:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbaFWBXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:23:25 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 4/4] ARM: dts: exynos5250: Add Spring device tree
Date: Mon, 23 Jun 2014 03:21:22 +0200
Message-Id: <1403486483-4063-5-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403486483-4063-1-git-send-email-afaerber@suse.de>
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds initial support for the HP Chromebook 11.

Cc: Vincent Palatin <vpalatin@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Stephan van Schaik <stephan@synkhronix.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 arch/arm/boot/dts/Makefile              |   1 +
 arch/arm/boot/dts/exynos5250-spring.dts | 556 ++++++++++++++++++++++++++++++++
 2 files changed, 557 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos5250-spring.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 5986ff6..dc2c5aa 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -74,6 +74,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 	exynos5250-arndale.dtb \
 	exynos5250-smdk5250.dtb \
 	exynos5250-snow.dtb \
+	exynos5250-spring.dtb \
 	exynos5260-xyref5260.dtb \
 	exynos5410-smdk5410.dtb \
 	exynos5420-arndale-octa.dtb \
diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
new file mode 100644
index 0000000..e857d44
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5250-spring.dts
@@ -0,0 +1,556 @@
+/*
+ * Google Spring board device tree source
+ *
+ * Copyright (c) 2013 Google, Inc
+ * Copyright (c) 2014 SUSE LINUX Products GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include "exynos5250.dtsi"
+#include "exynos5250-cros-common.dtsi"
+
+/ {
+	model = "Google Spring";
+	compatible = "google,spring", "samsung,exynos5250", "samsung,exynos5";
+
+	pinctrl@11400000 {
+		s5m8767_dvs: s5m8767-dvs {
+			samsung,pins = "gpd1-0", "gpd1-1", "gpd1-2";
+			samsung,pin-function = <0>;
+			samsung,pin-pud = <1>;
+			samsung,pin-drv = <0>;
+		};
+
+		s5m8767_ds: s5m8767-ds {
+			samsung,pins = "gpx2-3", "gpx2-4", "gpx2-5";
+			samsung,pin-function = <0>;
+			samsung,pin-pud = <1>;
+			samsung,pin-drv = <0>;
+		};
+
+		tps65090_irq: tps65090-irq {
+			samsung,pins = "gpx2-6";
+			samsung,pin-function = <0>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		s5m8767_irq: s5m8767-irq {
+			samsung,pins = "gpx3-2";
+			samsung,pin-function = <0>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		hdmi_hpd_irq: hdmi-hpd-irq {
+			samsung,pins = "gpx3-7";
+			samsung,pin-function = <0>;
+			samsung,pin-pud = <1>;
+			samsung,pin-drv = <0>;
+		};
+	};
+
+	pinctrl@13400000 {
+		hsic_reset: hsic-reset {
+			samsung,pins = "gpe1-0";
+			samsung,pin-function = <1>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+	};
+
+	vbat: vbat-fixed-regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "vbat-supply";
+		regulator-boot-on;
+	};
+
+	usb@12000000 {
+		status = "okay";
+	};
+
+	usb3_vbus_reg: regulator-usb3 {
+		compatible = "regulator-fixed";
+		regulator-name = "P5.0V_USB3CON";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gpe1 0 1>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&hsic_reset>;
+		enable-active-high;
+	};
+
+	phy@12100000 {
+		vbus-supply = <&usb3_vbus_reg>;
+	};
+
+	usb@12110000 {
+		samsung,vbus-gpio = <&gpx1 1 0>;
+		status = "okay";
+	};
+
+	usb@12120000 {
+		status = "okay";
+	};
+
+	mmc@12220000 {
+		/* MMC2 pins are used as GPIO for eDP bridge control. */
+		status = "disabled";
+	};
+
+	mmc@12230000 {
+		status = "disabled";
+	};
+
+	i2c@12C60000 {
+		max77686@09 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			rtc {
+				reg = <0x6>;
+			};
+		};
+
+		s5m8767_pmic@66 {
+			compatible = "samsung,s5m8767-pmic";
+			reg = <0x66>;
+			interrupt-parent = <&gpx3>;
+			interrupts = <2 0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&s5m8767_irq &s5m8767_dvs &s5m8767_ds>;
+			wakeup-source;
+
+			s5m8767,pmic-buck-dvs-gpios = <&gpd1 0 1>, /* DVS1 */
+			                              <&gpd1 1 1>, /* DVS2 */
+			                              <&gpd1 2 1>; /* DVS3 */
+
+			s5m8767,pmic-buck-ds-gpios = <&gpx2 3 1>, /* SET1 */
+			                             <&gpx2 4 1>, /* SET2 */
+			                             <&gpx2 5 1>; /* SET3 */
+
+			/*
+			 * The following arrays of DVS voltages are not used, since we are
+			 * not using GPIOs to control PMIC bucks, but they must be defined
+			 * to please the driver.
+			 */
+			s5m8767,pmic-buck2-dvs-voltage = <1350000>, <1300000>,
+			                                 <1250000>, <1200000>,
+			                                 <1150000>, <1100000>,
+			                                 <1000000>, <950000>;
+
+			s5m8767,pmic-buck3-dvs-voltage = <1100000>, <1100000>,
+			                                 <1100000>, <1100000>,
+			                                 <1000000>, <1000000>,
+			                                 <1000000>, <1000000>;
+
+			s5m8767,pmic-buck4-dvs-voltage = <1200000>, <1200000>,
+			                                 <1200000>, <1200000>,
+			                                 <1200000>, <1200000>,
+			                                 <1200000>, <1200000>;
+
+			clocks {
+				compatible = "samsung,s5m8767-clk";
+				#clock-cells = <1>;
+				clock-output-names = "en32khz_ap",
+				                     "en32khz_cp",
+				                     "en32khz_bt";
+			};
+
+			regulators {
+				s5m_ldo4_reg: LDO4 {
+					regulator-name = "P1.0V_LDO_OUT4";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+					op_mode = <0>;
+				};
+
+				s5m_ldo5_reg: LDO5 {
+					regulator-name = "P1.0V_LDO_OUT5";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+					op_mode = <0>;
+				};
+
+				s5m_ldo6_reg: LDO6 {
+					regulator-name = "vdd_mydp";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+					op_mode = <3>;
+				};
+
+				s5m_ldo7_reg: LDO7 {
+					regulator-name = "P1.1V_LDO_OUT7";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+					op_mode = <3>;
+				};
+
+				s5m_ldo8_reg: LDO8 {
+					regulator-name = "P1.0V_LDO_OUT8";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+					op_mode = <3>;
+				};
+
+				s5m_ldo10_reg: LDO10 {
+					regulator-name = "P1.8V_LDO_OUT10";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					op_mode = <3>;
+				};
+
+				s5m_ldo11_reg: LDO11 {
+					regulator-name = "P1.8V_LDO_OUT11";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					op_mode = <0>;
+				};
+
+				s5m_ldo12_reg: LDO12 {
+					regulator-name = "P3.0V_LDO_OUT12";
+					regulator-min-microvolt = <3000000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-always-on;
+					op_mode = <3>;
+				};
+
+				s5m_ldo13_reg: LDO13 {
+					regulator-name = "P1.8V_LDO_OUT13";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					op_mode = <0>;
+				};
+
+				s5m_ldo14_reg: LDO14 {
+					regulator-name = "P1.8V_LDO_OUT14";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					op_mode = <3>;
+				};
+
+				s5m_ldo15_reg: LDO15 {
+					regulator-name = "P1.0V_LDO_OUT15";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+					op_mode = <3>;
+				};
+
+				s5m_ldo16_reg: LDO16 {
+					regulator-name = "P1.8V_LDO_OUT16";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					op_mode = <3>;
+				};
+
+				s5m_ldo17_reg: LDO17 {
+					regulator-name = "P2.8V_LDO_OUT17";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+					op_mode = <0>;
+				};
+
+				s5m_ldo25_reg: LDO25 {
+					regulator-name = "vdd_bridge";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+					op_mode = <1>;
+				};
+
+				BUCK1 {
+					regulator-name = "vdd_mif";
+					regulator-min-microvolt = <950000>;
+					regulator-max-microvolt = <1300000>;
+					regulator-always-on;
+					regulator-boot-on;
+					op_mode = <3>;
+				};
+
+				BUCK2 {
+					regulator-name = "vdd_arm";
+					regulator-min-microvolt = <850000>;
+					regulator-max-microvolt = <1350000>;
+					regulator-always-on;
+					regulator-boot-on;
+					op_mode = <3>;
+				};
+
+				BUCK3 {
+					regulator-name = "vdd_int";
+					regulator-min-microvolt = <900000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+					regulator-boot-on;
+					op_mode = <3>;
+				};
+
+				BUCK4 {
+					regulator-name = "vdd_g3d";
+					regulator-min-microvolt = <850000>;
+					regulator-max-microvolt = <1300000>;
+					regulator-boot-on;
+					op_mode = <3>;
+				};
+
+				BUCK5 {
+					regulator-name = "P1.8V_BUCK_OUT5";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					regulator-boot-on;
+					op_mode = <1>;
+				};
+
+				BUCK6 {
+					regulator-name = "P1.2V_BUCK_OUT6";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+					regulator-boot-on;
+					op_mode = <0>;
+				};
+
+				BUCK9 {
+					regulator-name = "vdd_ummc";
+					regulator-min-microvolt = <950000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-always-on;
+					regulator-boot-on;
+					op_mode = <3>;
+				};
+			};
+		};
+	};
+
+	i2c@12C70000 {
+		trackpad {
+			status = "disabled";
+		};
+	};
+
+	i2c@12CA0000 {
+		embedded-controller {
+			compatible = "google,cros-ec-i2c";
+			reg = <0x1e>;
+			interrupts = <6 0>;
+			interrupt-parent = <&gpx1>;
+			wakeup-source;
+
+			keyboard-controller {
+				compatible = "google,cros-ec-keyb";
+				keypad,num-rows = <8>;
+				keypad,num-columns = <13>;
+				google,needs-ghost-filter;
+				linux,keymap = <
+					0x0001007d	/* L_META */
+					0x0002003b	/* F1 */
+					0x00030030	/* B */
+					0x00040044	/* F10 */
+					0x00060031	/* N */
+					0x0008000d	/* = */
+					0x000a0064	/* R_ALT */
+
+					0x01010001	/* ESC */
+					0x0102003e	/* F4 */
+					0x01030022	/* G */
+					0x01040041	/* F7 */
+					0x01060023	/* H */
+					0x01080028	/* ' */
+					0x01090043	/* F9 */
+					0x010b000e	/* BKSPACE */
+
+					0x0200001d	/* L_CTRL */
+					0x0201000f	/* TAB */
+					0x0202003d	/* F3 */
+					0x02030014	/* T */
+					0x02040040	/* F6 */
+					0x0205001b	/* ] */
+					0x02060015	/* Y */
+					0x02070056	/* 102ND */
+					0x0208001a	/* [ */
+					0x02090042	/* F8 */
+
+					0x03010029	/* GRAVE */
+					0x0302003c	/* F2 */
+					0x03030006	/* 5 */
+					0x0304003f	/* F5 */
+					0x03060007	/* 6 */
+					0x0308000c	/* - */
+					0x030b002b	/* \ */
+
+					0x04000061	/* R_CTRL */
+					0x0401001e	/* A */
+					0x04020020	/* D */
+					0x04030021	/* F */
+					0x0404001f	/* S */
+					0x04050025	/* K */
+					0x04060024	/* J */
+					0x04080027	/* ; */
+					0x04090026	/* L */
+					0x040a002b	/* \ */
+					0x040b001c	/* ENTER */
+
+					0x0501002c	/* Z */
+					0x0502002e	/* C */
+					0x0503002f	/* V */
+					0x0504002d	/* X */
+					0x05050033	/* , */
+					0x05060032	/* M */
+					0x0507002a	/* L_SHIFT */
+					0x05080035	/* / */
+					0x05090034	/* . */
+					0x050B0039	/* SPACE */
+
+					0x06010002	/* 1 */
+					0x06020004	/* 3 */
+					0x06030005	/* 4 */
+					0x06040003	/* 2 */
+					0x06050009	/* 8 */
+					0x06060008	/* 7 */
+					0x0608000b	/* 0 */
+					0x0609000a	/* 9 */
+					0x060a0038	/* L_ALT */
+					0x060b006c	/* DOWN */
+					0x060c006a	/* RIGHT */
+
+					0x07010010	/* Q */
+					0x07020012	/* E */
+					0x07030013	/* R */
+					0x07040011	/* W */
+					0x07050017	/* I */
+					0x07060016	/* U */
+					0x07070036	/* R_SHIFT */
+					0x07080019	/* P */
+					0x07090018	/* O */
+					0x070b0067	/* UP */
+					0x070c0069	/* LEFT */
+				>;
+			};
+		};
+
+		power-regulator {
+			compatible = "ti,tps65090";
+			reg = <0x48>;
+
+			/*
+			 * Config irq to disable internal pulls
+			 * even though we run in polling mode.
+			 */
+			pinctrl-names = "default";
+			pinctrl-0 = <&tps65090_irq>;
+
+			vsys1-supply = <&vbat>;
+			vsys2-supply = <&vbat>;
+			vsys3-supply = <&vbat>;
+			infet1-supply = <&vbat>;
+			infet2-supply = <&vbat>;
+			infet3-supply = <&vbat>;
+			infet4-supply = <&vbat>;
+			infet5-supply = <&vbat>;
+			infet6-supply = <&vbat>;
+			infet7-supply = <&vbat>;
+			vsys-l1-supply = <&vbat>;
+			vsys-l2-supply = <&vbat>;
+
+			regulators {
+				fet1 {
+					regulator-name = "vcd_led";
+					regulator-min-microvolt = <12000000>;
+					regulator-max-microvolt = <12000000>;
+				};
+				fet3 {
+					regulator-name = "wwan_r";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+				fet5 {
+					regulator-name = "cam";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+				fet6 {
+					regulator-name = "lcd_vdd";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+				fet7 {
+					regulator-name = "ts";
+					regulator-min-microvolt = <5000000>;
+					regulator-max-microvolt = <5000000>;
+				};
+			};
+
+			charger {
+				compatible = "ti,tps65090-charger";
+			};
+		};
+	};
+
+	hdmi {
+		hdmi-en-supply = <&s5m_ldo8_reg>;
+		vdd-supply = <&s5m_ldo8_reg>;
+		vdd_osc-supply = <&s5m_ldo10_reg>;
+		vdd_pll-supply = <&s5m_ldo8_reg>;
+	};
+
+	fimd@14400000 {
+		status = "okay";
+		samsung,invert-vclk;
+	};
+
+	dp-controller@145B0000 {
+		status = "okay";
+		pinctrl-names = "default";
+		pinctrl-0 = <&dp_hpd>;
+		samsung,color-space = <0>;
+		samsung,dynamic-range = <0>;
+		samsung,ycbcr-coeff = <0>;
+		samsung,color-depth = <1>;
+		samsung,link-rate = <0x0a>;
+		samsung,lane-count = <1>;
+		samsung,hpd-gpio = <&gpc3 0 0>;
+
+		display-timings {
+			native-mode = <&timing1>;
+
+			timing1: timing@1 {
+				clock-frequency = <70589280>;
+				hactive = <1366>;
+				vactive = <768>;
+				hfront-porch = <40>;
+				hback-porch = <40>;
+				hsync-len = <32>;
+				vback-porch = <10>;
+				vfront-porch = <12>;
+				vsync-len = <6>;
+			};
+		};
+	};
+
+	fixed-rate-clocks {
+		xxti {
+			compatible = "samsung,clock-xxti";
+			clock-frequency = <24000000>;
+		};
+	};
+};
-- 
1.9.3

