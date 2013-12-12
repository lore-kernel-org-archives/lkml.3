Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3LLNed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:34:33 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12761 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3LLNe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:34:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Dec 2013 05:36:08 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <thierry.reding@gmail.com>, <rob.herring@calxeda.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: add ams AS3722 device to Venice2 DT
Date: Thu, 12 Dec 2013 19:01:04 +0530
Message-ID: <1386855064-10993-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1386855064-10993-1-git-send-email-ldewangan@nvidia.com>
References: <1386855064-10993-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ams AS3722 entry for gpio/pincontrol and regulators
to venice2 DT.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch is on top of the patch for pincontrol for venice2.
Tested with all regulator and sub driver registartion on Venice2.

 arch/arm/boot/dts/tegra124-venice2.dts |  285 +++++++++++++++++++++++++++++++-
 1 files changed, 284 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index 7a01171..423371f 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -350,6 +350,28 @@
 				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
 			};
 
+			spdif_in_pk6 {
+				nvidia,pins = "spdif_in_pk6";
+				nvidia,function = "rsvd3";
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+			};
+
+			dap3_dout_pp2 {
+				nvidia,pins = "dap2_dout_pp2";
+				nvidia,function = "rsvd4";
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+			};
+
+			kb_row0_pr0 {
+				nvidia,pins = "kb_row0_pr0";
+				nvidia,function = "rsvd4";
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+			};
+
 			drive_sdio1 {
 				nvidia,pins = "drive_sdio1";
 				nvidia,high-speed-mode = <TEGRA_PIN_ENABLE>;
@@ -419,7 +441,190 @@
 
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
+				vin-ldo1-6-supply = <&vdd_3v3_reg>;
+				vin-ldo2-5-7-supply = <&as3722_sd5>;
+				vin-ldo3-4-supply = <&vdd_ac_bat_reg>;
+				vin-ldo9-10-supply = <&vdd_ac_bat_reg>;
+				vin-ldo11-supply = <&vdd_3v3_reg>;
+
+				sd0 {
+					regulator-name = "vdd-cpu";
+					regulator-min-microvolt = <700000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-min-microamp = <3500000>;
+					regulator-max-microamp = <3500000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				sd1 {
+					regulator-name = "vdd-core";
+					regulator-min-microvolt = <700000>;
+					regulator-max-microvolt = <1350000>;
+					regulator-min-microamp = <2500000>;
+					regulator-max-microamp = <2500000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				as3722_sd2: sd2 {
+					regulator-name = "vddio-ddr";
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt = <1350000>;
+					regulator-boot-on;
+					regulator-always-on;
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
@@ -464,6 +669,84 @@
 		};
 	};
 
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vdd_ac_bat_reg: regulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "vdd_ac_bat";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+		};
+
+		vdd_3v3_reg: regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "vdd_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&as3722 1 GPIO_ACTIVE_HIGH>;
+		};
+
+		vdd_3v3_modem_reg: regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "vdd-modem-3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&as3722 2 GPIO_ACTIVE_HIGH>;
+		};
+
+		vdd_hdmi_5v0_reg: regulator@3 {
+			compatible = "regulator-fixed";
+			regulator-name = "vdd-hdmi-5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
+		};
+
+		vdd_bl_reg: regulator@4 {
+			compatible = "regulator-fixed";
+			regulator-name = "vdd-bl";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			gpio = <&gpio TEGRA_GPIO(P, 2) GPIO_ACTIVE_LOW>;
+		};
+
+		usb_vbus_hs_reg: regulator@5 {
+			compatible = "regulator-fixed";
+			regulator-name = "usb_vbus_hs";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio TEGRA_GPIO(N, 4) GPIO_ACTIVE_HIGH>;
+			gpio-open-drain;
+		};
+
+		usb_vbus_ss_reg: regulator@6 {
+			compatible = "regulator-fixed";
+			regulator-name = "usb_vbus_ss";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio TEGRA_GPIO(N, 5) GPIO_ACTIVE_HIGH>;
+			gpio-open-drain;
+		};
+
+		panel_3v3_reg: regulator@7 {
+			compatible = "regulator-fixed";
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
1.7.1.1

