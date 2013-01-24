Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3AXKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:16:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1821 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3AXKQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:16:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 24 Jan 2013 02:14:48 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] arm: tegra: dt: Add reset GPIO information to PHY DT node
Date: Thu, 24 Jan 2013 15:46:46 +0530
Message-ID: <1359022606-13359-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reset GPIO information is PHY specific detail, adding
it to PHY DT node.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |    3 +++
 arch/arm/boot/dts/tegra20-harmony.dts              |    4 ++++
 arch/arm/boot/dts/tegra20-paz00.dts                |    4 ++++
 arch/arm/boot/dts/tegra20-seaboard.dts             |    4 ++++
 arch/arm/boot/dts/tegra20-trimslice.dts            |    4 ++++
 arch/arm/boot/dts/tegra20-ventana.dts              |    4 ++++
 6 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
index 84a4c12..6bdaba2 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
@@ -7,6 +7,9 @@ Required properties :
  - reg : Address and length of the register set for the USB PHY interface.
  - phy_type : Should be one of "ulpi" or "utmi".
 
+Required properties for phy_type == ulpi:
+  - nvidia,phy-reset-gpio : The GPIO used to reset the PHY.
+
 Optional properties:
   - nvidia,has-legacy-mode : boolean indicates whether this controller can
     operate in legacy mode (as APX 2500 / 2600). In legacy mode some
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 96f4ccd..61d027f 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -431,6 +431,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5004400 {
+		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	};
+
 	sdhci@c8000200 {
 		status = "okay";
 		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index e4034b6..54d6fce 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -430,6 +430,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5004400 {
+		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+	};
+
 	sdhci@c8000000 {
 		status = "okay";
 		cd-gpios = <&gpio 173 0>; /* gpio PV5 */
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 0b48359..37b3a57 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -572,6 +572,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5004400 {
+		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	};
+
 	sdhci@c8000000 {
 		status = "okay";
 		power-gpios = <&gpio 86 0>; /* gpio PK6 */
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index adf6024..5d79e4f 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -314,6 +314,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5004400 {
+		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+	};
+
 	sdhci@c8000000 {
 		status = "okay";
 		bus-width = <4>;
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index 5b15c30..425c890 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -508,6 +508,10 @@
 		status = "okay";
 	};
 
+	usb-phy@c5004400 {
+		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	};
+
 	sdhci@c8000000 {
 		status = "okay";
 		power-gpios = <&gpio 86 0>; /* gpio PK6 */
-- 
1.7.0.4

