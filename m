Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926Ab3DCIz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:55:56 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10016 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab3DCIqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:46:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 03 Apr 2013 01:46:45 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <linux-tegra@vger.kernel.org>, <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v2 2/7] ARM: tegra: update device trees for USB binding rework
Date: Wed, 3 Apr 2013 14:11:37 +0530
Message-ID: <1364978502-22887-3-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com>
References: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com>
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
delta from v1:
1. Fixed voltage regulators were used for vbus-supply
2. Added UTMI PHY timing Parameters to DT.

 arch/arm/boot/dts/tegra20-colibri-512.dtsi |    4 ++
 arch/arm/boot/dts/tegra20-harmony.dts      |    8 ++--
 arch/arm/boot/dts/tegra20-iris-512.dts     |    4 ++
 arch/arm/boot/dts/tegra20-paz00.dts        |    8 ++--
 arch/arm/boot/dts/tegra20-seaboard.dts     |   22 +++++++++++--
 arch/arm/boot/dts/tegra20-trimslice.dts    |   21 ++++++++++--
 arch/arm/boot/dts/tegra20-ventana.dts      |    7 ++--
 arch/arm/boot/dts/tegra20.dtsi             |   46 ++++++++++++++++++++-------
 8 files changed, 89 insertions(+), 31 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index cb73e62..af5a7ae 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -443,6 +443,10 @@
 		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
 	};
 
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	};
+
 	sdhci@c8000600 {
 		cd-gpios = <&gpio 23 1>; /* gpio PC7 */
 	};
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 5fb0888..3454ce2 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -427,12 +427,12 @@
 		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
 	};
 
-	usb@c5008000 {
-		status = "okay";
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	usb@c5008000 {
+		status = "okay";
 	};
 
 	sdhci@c8000200 {
diff --git a/arch/arm/boot/dts/tegra20-iris-512.dts b/arch/arm/boot/dts/tegra20-iris-512.dts
index 52f1103..c99eccc 100644
--- a/arch/arm/boot/dts/tegra20-iris-512.dts
+++ b/arch/arm/boot/dts/tegra20-iris-512.dts
@@ -41,6 +41,10 @@
 		dr_mode = "otg";
 	};
 
+	usb-phy@c5000000 {
+		dr_mode = "otg";
+	};
+
 	usb@c5008000 {
 		status = "okay";
 	};
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 43fd28b..cc76129 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -426,12 +426,12 @@
 		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
 	};
 
-	usb@c5008000 {
-		status = "okay";
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+	usb@c5008000 {
+		status = "okay";
 	};
 
 	sdhci@c8000000 {
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 4f810a5..d234766 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -563,17 +563,22 @@
 		dr_mode = "otg";
 	};
 
+	usb-phy@c5000000 {
+		vbus-supply = <&vbus_reg>;
+		dr_mode = "otg";
+	};
+
 	usb@c5004000 {
 		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
 	};
 
-	usb@c5008000 {
-		status = "okay";
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	usb@c5008000 {
+		status = "okay";
 	};
 
 	sdhci@c8000000 {
@@ -786,6 +791,15 @@
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
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 955bf49..8f2bb9b 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -305,17 +305,21 @@
 		nvidia,vbus-gpio = <&gpio 170 0>; /* gpio PV2 */
 	};
 
+	usb-phy@c5000000 {
+		vbus-supply = <&vbus_reg>;
+	};
+
 	usb@c5004000 {
 		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
 	};
 
-	usb@c5008000 {
-		status = "okay";
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+	usb@c5008000 {
+		status = "okay";
 	};
 
 	sdhci@c8000000 {
@@ -357,6 +361,15 @@
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
index 3f8ae10..4c88b72 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -504,13 +504,14 @@
 		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
 	};
 
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	};
+
 	usb@c5008000 {
 		status = "okay";
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
-	};
 
 	sdhci@c8000000 {
 		status = "okay";
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 26c1134..9169d64 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -453,13 +453,23 @@
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
 	};
 
 	usb@c5004000 {
@@ -472,12 +482,14 @@
 		status = "disabled";
 	};
 
-	phy2: usb-phy@c5004400 {
+	phy2: usb-phy@c5004000 {
 		compatible = "nvidia,tegra20-usb-phy";
-		reg = <0xc5004400 0x3c00>;
+		reg = <0xc5004000 0x4000>;
 		phy_type = "ulpi";
-		clocks = <&tegra_car 94>, <&tegra_car 127>;
-		clock-names = "phy", "pll_u";
+		clocks = <&tegra_car 58>,
+			 <&tegra_car 127>,
+			 <&tegra_car 94>;
+		clock-names = "reg", "pll_u", "ulpi-link";
 	};
 
 	usb@c5008000 {
@@ -490,12 +502,22 @@
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
 	};
 
 	sdhci@c8000000 {
-- 
1.7.0.4

