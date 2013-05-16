Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3EPOWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:22:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2041 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3EPOWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:22:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 16 May 2013 07:22:11 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v4 3/8] ARM: tegra: update device trees for USB binding rework
Date: Thu, 16 May 2013 19:42:57 +0530
Message-ID: <1368713582-29038-4-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates all Tegra board files so that they contain all the
properties required by the updated USB DT binding. Note that this patch
only adds the new properties and does not yet remove the old properties,
in order to maintain bisectability. The old properties will be removed
once the driver has been updated to assume the new bindings.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v3:
Added status field to USB PHY DT nodes.

delta from v2:
1. Removed dr_mode setting to otg, due to lack of knowledge of all Vbus supplies,
 on all target platforms.

2. All changes related to 'nvidia,phy-reset-gpio' were moved to patch 2 of the
 same series.

delta from v1:
1. Fixed voltage regulators were used for vbus-supply
2. Added UTMI PHY timing Parameters to DT.

 arch/arm/boot/dts/tegra20-harmony.dts   |    9 ++++++
 arch/arm/boot/dts/tegra20-iris-512.dts  |    9 +++++-
 arch/arm/boot/dts/tegra20-paz00.dts     |    9 ++++++
 arch/arm/boot/dts/tegra20-seaboard.dts  |   20 ++++++++++++
 arch/arm/boot/dts/tegra20-tamonten.dtsi |    4 ++
 arch/arm/boot/dts/tegra20-trimslice.dts |   19 ++++++++++++
 arch/arm/boot/dts/tegra20-ventana.dts   |    9 ++++++
 arch/arm/boot/dts/tegra20-whistler.dts  |   28 +++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi          |   49 +++++++++++++++++++++++-------
 9 files changed, 143 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index e84f3f6..ec52937 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -428,12 +428,17 @@
 		status = "okay";
 	};
 
+	usb-phy@c5000000 {
+		status = "okay";
+	};
+
 	usb@c5004000 {
 		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
 	usb-phy@c5004000 {
+		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
@@ -441,6 +446,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5008000 {
+		status = "okay";
+	};
+
 	sdhci@c8000200 {
 		status = "okay";
 		cd-gpios = <&gpio 69 1>; /* gpio PI5 */
diff --git a/arch/arm/boot/dts/tegra20-iris-512.dts b/arch/arm/boot/dts/tegra20-iris-512.dts
index 52f1103..9f64f70 100644
--- a/arch/arm/boot/dts/tegra20-iris-512.dts
+++ b/arch/arm/boot/dts/tegra20-iris-512.dts
@@ -38,13 +38,20 @@
 
 	usb@c5000000 {
 		status = "okay";
-		dr_mode = "otg";
+	};
+
+	usb-phy@c5000000 {
+		status = "okay";
 	};
 
 	usb@c5008000 {
 		status = "okay";
 	};
 
+	usb-phy@c5008000 {
+		status = "okay";
+	};
+
 	serial@70006000 {
 		status = "okay";
 	};
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index e9ac2a9..1c17ffa 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -427,12 +427,17 @@
 		status = "okay";
 	};
 
+	usb-phy@c5000000 {
+		status = "okay";
+	};
+
 	usb@c5004000 {
 		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 168 1>; /* gpio PV0, active low */
 	};
 
 	usb-phy@c5004000 {
+		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 168 1>; /* gpio PV0, active low */
 	};
 
@@ -440,6 +445,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5008000 {
+		status = "okay";
+	};
+
 	sdhci@c8000000 {
 		status = "okay";
 		cd-gpios = <&gpio 173 1>; /* gpio PV5 */
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 9dd4f8e..b832088 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -569,12 +569,19 @@
 		dr_mode = "otg";
 	};
 
+	usb-phy@c5000000 {
+		status = "okay";
+		vbus-supply = <&vbus_reg>;
+		dr_mode = "otg";
+	};
+
 	usb@c5004000 {
 		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
 	usb-phy@c5004000 {
+		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
@@ -582,6 +589,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5008000 {
+		status = "okay";
+	};
+
 	sdhci@c8000000 {
 		status = "okay";
 		power-gpios = <&gpio 86 0>; /* gpio PK6 */
@@ -807,6 +818,15 @@
 			gpio = <&pmic 1 0>;
 			enable-active-high;
 		};
+
+		vbus_reg: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "vdd_5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio 24 0>; /* PD0 */
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 50b3ec1..fc2f7d6 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -470,6 +470,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5008000 {
+		status = "okay";
+	};
+
 	sdhci@c8000600 {
 		cd-gpios = <&gpio 58 1>; /* gpio PH2 */
 		wp-gpios = <&gpio 59 0>; /* gpio PH3 */
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index fd7afd6..d9b58cd 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -314,12 +314,18 @@
 		nvidia,vbus-gpio = <&gpio 170 0>; /* gpio PV2 */
 	};
 
+	usb-phy@c5000000 {
+		status = "okay";
+		vbus-supply = <&vbus_reg>;
+	};
+
 	usb@c5004000 {
 		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 168 1>; /* gpio PV0, active low */
 	};
 
 	usb-phy@c5004000 {
+		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 168 1>; /* gpio PV0, active low */
 	};
 
@@ -327,6 +333,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5008000 {
+		status = "okay";
+	};
+
 	sdhci@c8000000 {
 		status = "okay";
 		bus-width = <4>;
@@ -390,6 +400,15 @@
 			regulator-max-microvolt = <1800000>;
 			regulator-always-on;
 		};
+
+		vbus_reg: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "vdd_5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio 170 0>; /* PV2 */
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index a75a0e7..e00f89e 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -505,12 +505,17 @@
 		status = "okay";
 	};
 
+	usb-phy@c5000000 {
+		status = "okay";
+	};
+
 	usb@c5004000 {
 		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
 	usb-phy@c5004000 {
+		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
@@ -518,6 +523,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5008000 {
+		status = "okay";
+	};
+
 	sdhci@c8000000 {
 		status = "okay";
 		power-gpios = <&gpio 86 0>; /* gpio PK6 */
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index d2567f8..e405c2f 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -511,11 +511,21 @@
 		nvidia,vbus-gpio = <&tca6416 0 0>; /* GPIO_PMU0 */
 	};
 
+	usb-phy@c5000000 {
+		status = "okay";
+		vbus-supply = <&vbus_reg1>;
+	};
+
 	usb@c5008000 {
 		status = "okay";
 		nvidia,vbus-gpio = <&tca6416 1 0>; /* GPIO_PMU1 */
 	};
 
+	usb-phy@c5008000 {
+		status = "okay";
+		vbus-supply = <&vbus_reg2>;
+	};
+
 	sdhci@c8000400 {
 		status = "okay";
 		cd-gpios = <&gpio 69 1>; /* gpio PI5 */
@@ -568,6 +578,24 @@
 			regulator-max-microvolt = <5000000>;
 			regulator-always-on;
 		};
+
+		vbus_reg1: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "vdd_5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&tca6416 0 0>; /* GPIO_PMU0 */
+		};
+
+		vbus_reg2: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "vdd_5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&tca6416 1 0>; /* GPIO_PMU1 */
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 56a9110..96d6d8a 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -455,13 +455,24 @@
 		status = "disabled";
 	};
 
-	phy1: usb-phy@c5000400 {
+	phy1: usb-phy@c5000000 {
 		compatible = "nvidia,tegra20-usb-phy";
-		reg = <0xc5000400 0x3c00>;
+		reg = <0xc5000000 0x4000 0xc5000000 0x4000>;
 		phy_type = "utmi";
+		clocks = <&tegra_car 22>,
+			 <&tegra_car 127>,
+			 <&tegra_car 106>,
+			 <&tegra_car 22>;
+		clock-names = "reg", "pll_u", "timer", "utmi-pads";
 		nvidia,has-legacy-mode;
-		clocks = <&tegra_car 22>, <&tegra_car 127>;
-		clock-names = "phy", "pll_u";
+		hssync_start_delay = <9>;
+		idle_wait_delay = <17>;
+		elastic_limit = <16>;
+		term_range_adj = <6>;
+		xcvr_setup = <9>;
+		xcvr_lsfslew = <1>;
+		xcvr_lsrslew = <1>;
+		status = "disabled";
 	};
 
 	usb@c5004000 {
@@ -474,12 +485,15 @@
 		status = "disabled";
 	};
 
-	phy2: usb-phy@c5004400 {
+	phy2: usb-phy@c5004000 {
 		compatible = "nvidia,tegra20-usb-phy";
-		reg = <0xc5004400 0x3c00>;
+		reg = <0xc5004000 0x4000>;
 		phy_type = "ulpi";
-		clocks = <&tegra_car 93>, <&tegra_car 127>;
-		clock-names = "phy", "pll_u";
+		clocks = <&tegra_car 58>,
+			 <&tegra_car 127>,
+			 <&tegra_car 93>;
+		clock-names = "reg", "pll_u", "ulpi-link";
+		status = "disabled";
 	};
 
 	usb@c5008000 {
@@ -492,12 +506,23 @@
 		status = "disabled";
 	};
 
-	phy3: usb-phy@c5008400 {
+	phy3: usb-phy@c5008000 {
 		compatible = "nvidia,tegra20-usb-phy";
-		reg = <0xc5008400 0x3c00>;
+		reg = <0xc5008000 0x4000 0xc5000000 0x4000>;
 		phy_type = "utmi";
-		clocks = <&tegra_car 22>, <&tegra_car 127>;
-		clock-names = "phy", "pll_u";
+		clocks = <&tegra_car 59>,
+			 <&tegra_car 127>,
+			 <&tegra_car 106>,
+			 <&tegra_car 22>;
+		clock-names = "reg", "pll_u", "timer", "utmi-pads";
+		hssync_start_delay = <9>;
+		idle_wait_delay = <17>;
+		elastic_limit = <16>;
+		term_range_adj = <6>;
+		xcvr_setup = <9>;
+		xcvr_lsfslew = <2>;
+		xcvr_lsrslew = <2>;
+		status = "disabled";
 	};
 
 	sdhci@c8000000 {
-- 
1.7.0.4

