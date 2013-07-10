Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3GJH3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:29:25 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19526 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3GJH3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:29:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Jul 2013 00:28:24 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] ARM: tegra: enable palmas device for dalmore
Date: Wed, 10 Jul 2013 13:07:32 +0530
Message-ID: <1373441852-27176-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the entry of Dalmore Power Management Unit device TPS65913
in dalmore DTS file. The Palma driver support this device.

Enable following submodule of the TPS65913:
- GPIO driver
- RTC driver.
- Power regulator driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- renames nodes from palams_* to simple as gpio, rtc, pmic etc.
- Added line gap properly.
- Remove comment for palams-gpio reference as the entry itself explain.
- Remove unit address for tps65913.

 arch/arm/boot/dts/tegra114-dalmore.dts |  184 +++++++++++++++++++++++++++++++-
 1 files changed, 183 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index a42bfa4..7bdad77 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -791,7 +791,7 @@
 					regulator-boot-on;
 				};
 
-				dcdc3 {
+				tps65090_dcdc3_reg: dcdc3 {
 					regulator-name = "vdd-ao";
 					regulator-always-on;
 					regulator-boot-on;
@@ -836,6 +836,178 @@
 				};
 			};
 		};
+
+		palmas: tps65913 {
+			compatible = "ti,palmas";
+			reg = <0x58>;
+			interrupts = <0 86 0x4>;
+
+			#interrupt-cells = <2>;
+			interrupt-controller;
+
+			palmas_gpio: gpio {
+				compatible = "ti,palmas-gpio";
+				gpio-controller;
+				#gpio-cells = <2>;
+			};
+
+			rtc {
+				compatible = "ti,palmas-rtc";
+				interrupt-parent = <&palmas>;
+				interrupts = <8 0>;
+			};
+
+			pmic {
+			    compatible = "ti,tps65913-pmic", "ti,palmas-pmic";
+			    smps1-in-supply = <&tps65090_dcdc3_reg>;
+			    smps3-in-supply = <&tps65090_dcdc3_reg>;
+			    smps4-in-supply = <&tps65090_dcdc2_reg>;
+			    smps7-in-supply = <&tps65090_dcdc2_reg>;
+			    smps8-in-supply = <&tps65090_dcdc2_reg>;
+			    smps9-in-supply = <&tps65090_dcdc2_reg>;
+			    ldo1-in-supply = <&tps65090_dcdc2_reg>;
+			    ldo2-in-supply = <&tps65090_dcdc2_reg>;
+			    ldo3-in-supply = <&palmas_smps3_reg>;
+			    ldo4-in-supply = <&tps65090_dcdc2_reg>;
+			    ldo5-in-supply = <&vdd_ac_bat_reg>;
+			    ldo6-in-supply = <&tps65090_dcdc2_reg>;
+			    ldo7-in-supply = <&tps65090_dcdc2_reg>;
+			    ldo8-in-supply = <&tps65090_dcdc3_reg>;
+			    ldo9-in-supply = <&palmas_smps9_reg>;
+			    ldoln-in-supply = <&tps65090_dcdc1_reg>;
+			    ldousb-in-supply = <&tps65090_dcdc1_reg>;
+
+			    regulators {
+				smps12 {
+					regulator-name = "vddio-ddr";
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt = <1350000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				palmas_smps3_reg: smps3 {
+					regulator-name = "vddio-1v8";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				smps45 {
+					regulator-name = "vdd-core";
+					regulator-min-microvolt = <900000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				smps457 {
+					regulator-name = "vdd-core";
+					regulator-min-microvolt = <900000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				smps8 {
+					regulator-name = "avdd-pll";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				palmas_smps9_reg: smps9 {
+					regulator-name = "sdhci-vdd-sd-slot";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo1 {
+					regulator-name = "avdd-cam1";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo2 {
+					regulator-name = "avdd-cam2";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo3 {
+					regulator-name = "avdd-dsi-csi";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo4 {
+					regulator-name = "vpp-fuse";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+				};
+
+				ldo6 {
+					regulator-name = "vdd-sensor-2v85";
+					regulator-min-microvolt = <2850000>;
+					regulator-max-microvolt = <2850000>;
+				};
+
+				ldo7 {
+					regulator-name = "vdd-af-cam1";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo8 {
+					regulator-name = "vdd-rtc";
+					regulator-min-microvolt = <900000>;
+					regulator-max-microvolt = <900000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ti,enable-ldo8-tracking;
+				};
+
+				ldo9 {
+					regulator-name = "vddio-sdmmc-2";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldoln {
+					regulator-name = "hvdd-usb";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldousb {
+					regulator-name = "avdd-usb";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				regen1 {
+					regulator-name = "rail-3v3";
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				regen2 {
+					regulator-name = "rail-5v0";
+					regulator-max-microvolt = <5000000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+			    };
+			};
+		};
 	};
 
 	spi@7000da00 {
@@ -980,6 +1152,16 @@
 			gpio = <&gpio TEGRA_GPIO(K, 1) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&tps65090_dcdc1_reg>;
 		};
+
+		vdd_cam_1v8_reg: regulator@6 {
+			compatible = "regulator-fixed";
+			reg = <6>;
+			regulator-name = "vdd_cam_1v8_reg";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			enable-active-high;
+			gpio = <&palmas_gpio 6 0>;
+		};
 	};
 
 	sound {
-- 
1.7.1.1

