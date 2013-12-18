Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3LRMxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:53:22 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14643 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3LRMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:53:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Dec 2013 04:55:28 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <thierry.reding@gmail.com>, <mark.rutland@arm.com>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/2] ARM: tegra: add ams AS3722 device to Venice2 DT
Date: Wed, 18 Dec 2013 18:22:59 +0530
Message-ID: <1387371179-16725-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387371179-16725-1-git-send-email-ldewangan@nvidia.com>
References: <1387371179-16725-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ams AS3722 entry for gpio/pincontrol and regulators
to venice2 DT.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes fome V1:
- Separte the pinmux change on different patch.
- Compare the conifguration with chorme internal branch for Venice2.

 arch/arm/boot/dts/tegra124-venice2.dts |  297 +++++++++++++++++++++++++++++++-
 1 file changed, 296 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index 6bc4e07..a9f0df9 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -603,7 +603,201 @@
 
 	i2c@7000d000 {
 		status = "okay";
-		clock-frequency = <100000>;
+		clock-frequency = <400000>;
+
+		as3722: as3722@40 {
+			compatible = "ams,as3722";
+			reg = <0x40>;
+			interrupts = <0 86 IRQ_TYPE_LEVEL_HIGH>;
+
+			#interrupt-cells = <2>;
+			interrupt-controller;
+
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			pinctrl-names = "default";
+			pinctrl-0 = <&as3722_default>;
+
+			as3722_default: pinmux {
+				gpio0 {
+					pins = "gpio0";
+					function = "gpio";
+					bias-pull-down;
+				};
+
+				gpio1_2_4_7 {
+					pins = "gpio1", "gpio2", "gpio4", "gpio7";
+					function = "gpio";
+					bias-pull-up;
+				};
+
+				gpio3_6 {
+					pins = "gpio3", "gpio6";
+					bias-high-impedance;
+				};
+
+				gpio5 {
+					pins = "gpio5";
+					function = "clk32k-out";
+				};
+			};
+
+			regulators {
+				vsup-sd2-supply = <&vdd_ac_bat_reg>;
+				vsup-sd3-supply = <&vdd_ac_bat_reg>;
+				vsup-sd4-supply = <&vdd_ac_bat_reg>;
+				vsup-sd5-supply = <&vdd_ac_bat_reg>;
+				vin-ldo0-supply = <&as3722_sd2>;
+				vin-ldo1-6-supply = <&vdd_ac_bat_reg>;
+				vin-ldo2-5-7-supply = <&as3722_sd5>;
+				vin-ldo3-4-supply = <&vdd_ac_bat_reg>;
+				vin-ldo9-10-supply = <&vdd_ac_bat_reg>;
+				vin-ldo11-supply = <&vdd_ac_bat_reg>;
+
+				sd0 {
+					regulator-name = "vdd-cpu";
+					regulator-min-microvolt = <700000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-min-microamp = <3500000>;
+					regulator-max-microamp = <3500000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ams,external-control = <2>;
+				};
+
+				sd1 {
+					regulator-name = "vdd-core";
+					regulator-min-microvolt = <700000>;
+					regulator-max-microvolt = <1350000>;
+					regulator-min-microamp = <2500000>;
+					regulator-max-microamp = <2500000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ams,external-control = <1>;
+				};
+
+				as3722_sd2: sd2 {
+					regulator-name = "vddio-ddr";
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt = <1350000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				sd3 {
+					regulator-name = "vddio-ddr-2phase";
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt = <1350000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				sd4 {
+					regulator-name = "avdd-pex-sata";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				as3722_sd5: sd5 {
+					regulator-name = "vddio-sys";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				sd6 {
+					regulator-name = "vdd-gpu";
+					regulator-min-microvolt = <650000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-min-microamp = <3500000>;
+					regulator-max-microamp = <3500000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				ldo0 {
+					regulator-name = "avdd_pll";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+					regulator-boot-on;
+					regulator-always-on;
+					ams,external-control = <1>;
+				};
+
+				ldo1 {
+					regulator-name = "run-cam-1.8";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+				};
+
+				ldo2 {
+					regulator-name = "gen-avdd,vddio-hsic";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				ldo3 {
+					regulator-name = "vdd-rtc";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-boot-on;
+					regulator-always-on;
+					ams,enable-tracking;
+				};
+
+				ldo4 {
+					regulator-name = "vdd-cam";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				ldo5 {
+					regulator-name = "vdd-cam-front";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				ldo6 {
+					regulator-name = "vddio-sdmmc3";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				ldo7 {
+					regulator-name = "vdd-cam-rear";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+				};
+
+				ldo9 {
+					regulator-name = "vdd-touch";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo10 {
+					regulator-name = "vdd-cam-af";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo11 {
+					regulator-name = "vpp-fuse";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+				};
+			};
+		};
 	};
 
 	pmc@7000e400 {
@@ -648,6 +842,107 @@
 		};
 	};
 
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vdd_ac_bat_reg: regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "vdd_ac_bat";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+		};
+
+		vdd_3v3_reg: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "vdd_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&as3722 1 GPIO_ACTIVE_HIGH>;
+		};
+
+		vdd_3v3_modem_reg: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "vdd-modem-3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&as3722 2 GPIO_ACTIVE_HIGH>;
+		};
+
+		vdd_hdmi_5v0_reg: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "vdd-hdmi-5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
+		};
+
+		vdd_bl_reg: regulator@4 {
+			compatible = "regulator-fixed";
+			reg = <4>;
+			regulator-name = "vdd-bl";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			gpio = <&gpio TEGRA_GPIO(P, 2) GPIO_ACTIVE_LOW>;
+		};
+
+		vdd_ts_sw_5v0: regulator@5 {
+			compatible = "regulator-fixed";
+			reg = <5>;
+			regulator-name = "vdd_ts_sw";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			regulator-boot-on;
+			gpio = <&gpio TEGRA_GPIO(K, 1) GPIO_ACTIVE_LOW>;
+		};
+
+		usb1_vbus_reg: regulator@6 {
+			compatible = "regulator-fixed";
+			reg = <6>;
+			regulator-name = "usb1_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&gpio TEGRA_GPIO(N, 4) GPIO_ACTIVE_HIGH>;
+			gpio-open-drain;
+		};
+
+		usb3_vbus_reg: regulator@7 {
+			compatible = "regulator-fixed";
+			reg = <7>;
+			regulator-name = "usb3_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&gpio TEGRA_GPIO(N, 5) GPIO_ACTIVE_HIGH>;
+			gpio-open-drain;
+		};
+
+		panel_3v3_reg: regulator@8 {
+			compatible = "regulator-fixed";
+			reg = <8>;
+			regulator-name = "panel_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&as3722 4 GPIO_ACTIVE_HIGH>;
+		};
+	};
+
 	sound {
 		compatible = "nvidia,tegra-audio-max98090-venice2",
 			     "nvidia,tegra-audio-max98090";
-- 
1.7.9.5

