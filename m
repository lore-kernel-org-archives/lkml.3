Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3EJODP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:03:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11800 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3EJODM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:03:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 10 May 2013 07:02:55 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v3 02/10] arm: dt: Tegra20: Modify ULPI reset GPIO properties
Date: Fri, 10 May 2013 19:24:03 +0530
Message-ID: <1368194051-4925-3-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes with this patch:
1. All Tegra20 ULPI reset GPIO DT properties are modified to indicate active
low nature of the GPIO.
2. Placed USB PHY DT node immediately below the EHCI controller DT nodes
and corrected reg value in the name of USB PHY DT node.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
Created this patch as per comments received at:
http://marc.info/?l=linux-usb&m=136501761810344&w=2

 arch/arm/boot/dts/tegra20-colibri-512.dtsi |    6 +++++-
 arch/arm/boot/dts/tegra20-harmony.dts      |   10 +++++-----
 arch/arm/boot/dts/tegra20-paz00.dts        |   10 +++++-----
 arch/arm/boot/dts/tegra20-seaboard.dts     |   10 +++++-----
 arch/arm/boot/dts/tegra20-trimslice.dts    |   10 +++++-----
 arch/arm/boot/dts/tegra20-ventana.dts      |   10 +++++-----
 6 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index a573b94..c12af78 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -449,7 +449,11 @@
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
+	};
+
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
 	sdhci@c8000600 {
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index e7d5de4..e84f3f6 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -430,15 +430,15 @@
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
-	usb@c5008000 {
-		status = "okay";
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	usb@c5008000 {
+		status = "okay";
 	};
 
 	sdhci@c8000200 {
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index e3e0c99..e9ac2a9 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -429,15 +429,15 @@
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+		nvidia,phy-reset-gpio = <&gpio 168 1>; /* gpio PV0, active low */
 	};
 
-	usb@c5008000 {
-		status = "okay";
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 168 1>; /* gpio PV0, active low */
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+	usb@c5008000 {
+		status = "okay";
 	};
 
 	sdhci@c8000000 {
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index cee4c34..9dd4f8e 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -571,15 +571,15 @@
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
-	usb@c5008000 {
-		status = "okay";
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	usb@c5008000 {
+		status = "okay";
 	};
 
 	sdhci@c8000000 {
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 9cc78a1..fd7afd6 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -316,15 +316,15 @@
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+		nvidia,phy-reset-gpio = <&gpio 168 1>; /* gpio PV0, active low */
 	};
 
-	usb@c5008000 {
-		status = "okay";
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 168 1>; /* gpio PV0, active low */
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+	usb@c5008000 {
+		status = "okay";
 	};
 
 	sdhci@c8000000 {
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index dd38f1f..a75a0e7 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -507,15 +507,15 @@
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
-	usb@c5008000 {
-		status = "okay";
+	usb-phy@c5004000 {
+		nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */
 	};
 
-	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+	usb@c5008000 {
+		status = "okay";
 	};
 
 	sdhci@c8000000 {
-- 
1.7.0.4

