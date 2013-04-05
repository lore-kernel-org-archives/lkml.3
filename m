Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162799Ab3DEU0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:26:09 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40664 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162750Ab3DEUYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:24:23 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v2 5/9] arm: dts: mvebu: move all peripherals inside soc
Date: Fri,  5 Apr 2013 22:24:00 +0200
Message-Id: <1365193444-13441-6-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 arch/arm/boot/dts/armada-370-xp.dtsi |   26 +++++++++++++-------------
 arch/arm/boot/dts/armada-370.dtsi    |   23 ++++++++++++-----------
 arch/arm/boot/dts/armada-xp.dtsi     |   32 ++++++++++++++++----------------
 3 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 5b70820..bd26c48 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -28,19 +28,6 @@
 		};
 	};
 
-	mpic: interrupt-controller@d0020000 {
-	      compatible = "marvell,mpic";
-	      #interrupt-cells = <1>;
-	      #size-cells = <1>;
-	      interrupt-controller;
-	};
-
-	coherency-fabric@d0020200 {
-		compatible = "marvell,coherency-fabric";
-		reg = <0xd0020200 0xb0>,
-		      <0xd0021810 0x1c>;
-	};
-
 	soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -48,6 +35,19 @@
 		interrupt-parent = <&mpic>;
 		ranges;
 
+		mpic: interrupt-controller@d0020000 {
+			compatible = "marvell,mpic";
+			#interrupt-cells = <1>;
+			#size-cells = <1>;
+			interrupt-controller;
+		};
+
+		coherency-fabric@d0020200 {
+			compatible = "marvell,coherency-fabric";
+			reg = <0xd0020200 0xb0>,
+			      <0xd0021810 0x1c>;
+		};
+
 		serial@d0012000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0xd0012000 0x100>;
diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index 8188d13..03808aa 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -20,12 +20,6 @@
 / {
 	model = "Marvell Armada 370 family SoC";
 	compatible = "marvell,armada370", "marvell,armada-370-xp";
-	L2: l2-cache {
-		compatible = "marvell,aurora-outer-cache";
-		reg = <0xd0008000 0x1000>;
-		cache-id-part = <0x100>;
-		wt-override;
-	};
 
 	aliases {
 		gpio0 = &gpio0;
@@ -33,17 +27,24 @@
 		gpio2 = &gpio2;
 	};
 
-	mpic: interrupt-controller@d0020000 {
-	      reg = <0xd0020a00 0x1d0>,
-		    <0xd0021870 0x58>;
-	};
-
 	soc {
+		mpic: interrupt-controller@d0020000 {
+			reg = <0xd0020a00 0x1d0>,
+			      <0xd0021870 0x58>;
+		};
+
 		system-controller@d0018200 {
 				compatible = "marvell,armada-370-xp-system-controller";
 				reg = <0xd0018200 0x100>;
 		};
 
+		L2: l2-cache {
+			compatible = "marvell,aurora-outer-cache";
+			reg = <0xd0008000 0x1000>;
+			cache-id-part = <0x100>;
+			wt-override;
+		};
+
 		pinctrl {
 			compatible = "marvell,mv88f6710-pinctrl";
 			reg = <0xd0018000 0x38>;
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index ca00d83..e644cc5 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -22,25 +22,25 @@
 	model = "Marvell Armada XP family SoC";
 	compatible = "marvell,armadaxp", "marvell,armada-370-xp";
 
-	L2: l2-cache {
-		compatible = "marvell,aurora-system-cache";
-		reg = <0xd0008000 0x1000>;
-		cache-id-part = <0x100>;
-		wt-override;
-	};
+	soc {
+		L2: l2-cache {
+			compatible = "marvell,aurora-system-cache";
+			reg = <0xd0008000 0x1000>;
+			cache-id-part = <0x100>;
+			wt-override;
+		};
 
-	mpic: interrupt-controller@d0020000 {
-	      reg = <0xd0020a00 0x2d0>,
-		    <0xd0021070 0x58>;
-	};
+		mpic: interrupt-controller@d0020000 {
+		      reg = <0xd0020a00 0x2d0>,
+			    <0xd0021070 0x58>;
+		};
 
-	armada-370-xp-pmsu@d0022000 {
-		compatible = "marvell,armada-370-xp-pmsu";
-		reg = <0xd0022100 0x430>,
-		      <0xd0020800 0x20>;
-	};
+		armada-370-xp-pmsu@d0022000 {
+			compatible = "marvell,armada-370-xp-pmsu";
+			reg = <0xd0022100 0x430>,
+			      <0xd0020800 0x20>;
+		};
 
-	soc {
 		serial@d0012200 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0xd0012200 0x100>;
-- 
1.7.9.5

