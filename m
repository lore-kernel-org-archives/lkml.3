Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3CRMdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:33:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6415 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab3CRMda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:33:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 18 Mar 2013 05:33:26 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 2/7] ARM: tegra: update device trees for USB binding rework
Date: Mon, 18 Mar 2013 17:59:36 +0530
Message-ID: <1363609781-4045-3-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
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
 arch/arm/boot/dts/tegra20-colibri-512.dtsi |    4 +++
 arch/arm/boot/dts/tegra20-harmony.dts      |    8 +++---
 arch/arm/boot/dts/tegra20-iris-512.dts     |    4 +++
 arch/arm/boot/dts/tegra20-paz00.dts        |    8 +++---
 arch/arm/boot/dts/tegra20-seaboard.dts     |   13 +++++++---
 arch/arm/boot/dts/tegra20-trimslice.dts    |   12 +++++++---
 arch/arm/boot/dts/tegra20-ventana.dts      |    7 +++--
 arch/arm/boot/dts/tegra20.dtsi             |   32 +++++++++++++++++----------
 8 files changed, 57 insertions(+), 31 deletions(-)

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
index 1f79c0d..14dd6ed 100644
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
index 9db36da..cc3c032 100644
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
index 715a8b8..320964f 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -563,17 +563,22 @@
 		dr_mode = "otg";
 	};
 
+	usb-phy@c5000000 {
+		nvidia,vbus-gpio = <&gpio 24 0>; /* PD0 */
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
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 98f3e44..3a8d6ed 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -305,17 +305,21 @@
 		nvidia,vbus-gpio = <&gpio 170 0>; /* gpio PV2 */
 	};
 
+	usb-phy@c5000000 {
+		nvidia,vbus-gpio = <&gpio 170 0>; /* gpio PV2 */
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
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index 4aef56f..f566fd7 100644
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
index 3183581..9eb1085 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -453,13 +453,16 @@
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
 	};
 
 	usb@c5004000 {
@@ -472,12 +475,14 @@
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
@@ -490,12 +495,15 @@
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
 	};
 
 	sdhci@c8000000 {
-- 
1.7.0.4

