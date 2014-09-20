Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbaITSHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:07:51 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38817 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbaITSGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:06:40 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/5] ARM: mvebu: armada-xp: Correct misnumbered PCIe port nodes
Date: Sat, 20 Sep 2014 20:06:29 +0200
Message-Id: <1411236391-422-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1411236391-422-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1411236391-422-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, Armada XP PCIe nodes are numbered pcie@<N>,0 with N just
incrementing. To reflect port/lane relationship, rename the nodes
to pcie@<port>,<lane>. While at it, add node aliases to each of pcie
controller and port nodes and get rid of now redundant port/lane
comments.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org> 
Cc: Pawel Moll <pawel.moll@arm.com> 
Cc: Mark Rutland <mark.rutland@arm.com> 
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk> 
Cc: Kumar Gala <galak@codeaurora.org> 
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Cooper <jason@lakedaemon.net> 
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com> 
Cc: devicetree@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/boot/dts/armada-xp-axpwifiap.dts        | 11 ++++-------
 arch/arm/boot/dts/armada-xp-db.dts               | 20 +++++++-------------
 arch/arm/boot/dts/armada-xp-gp.dts               | 11 ++++-------
 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts  |  8 +++-----
 arch/arm/boot/dts/armada-xp-matrix.dts           |  5 ++---
 arch/arm/boot/dts/armada-xp-mv78230.dtsi         | 12 ++++++------
 arch/arm/boot/dts/armada-xp-mv78260.dtsi         | 20 ++++++++++----------
 arch/arm/boot/dts/armada-xp-mv78460.dtsi         | 22 +++++++++++-----------
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts   | 11 ++++-------
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  5 ++---
 10 files changed, 53 insertions(+), 72 deletions(-)

diff --git a/arch/arm/boot/dts/armada-xp-axpwifiap.dts b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
index 0e53fad111de..1b2dd3a4000b 100644
--- a/arch/arm/boot/dts/armada-xp-axpwifiap.dts
+++ b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
@@ -37,24 +37,21 @@
 		ranges = <MBUS_ID(0xf0, 0x01) 0 0 0xf1000000 0x100000
 			  MBUS_ID(0x01, 0x1d) 0 0 0xfff00000 0x100000>;
 
-		pcie-controller {
+		pcie: pcie-controller {
 			status = "okay";
 
 			/* First mini-PCIe port */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			pcie00: pcie@0,0 {
 				status = "okay";
 			};
 
 			/* Second mini-PCIe port */
-			pcie@2,0 {
-				/* Port 0, Lane 1 */
+			pcie01: pcie@0,1 {
 				status = "okay";
 			};
 
 			/* Renesas uPD720202 USB 3.0 controller */
-			pcie@3,0 {
-				/* Port 0, Lane 3 */
+			pcie03: pcie@0,3 {
 				status = "okay";
 			};
 		};
diff --git a/arch/arm/boot/dts/armada-xp-db.dts b/arch/arm/boot/dts/armada-xp-db.dts
index 42ddb2864365..3cda0f6e5c37 100644
--- a/arch/arm/boot/dts/armada-xp-db.dts
+++ b/arch/arm/boot/dts/armada-xp-db.dts
@@ -71,35 +71,29 @@
 			};
 		};
 
-		pcie-controller {
+		pcie: pcie-controller {
 			status = "okay";
 
 			/*
 			 * All 6 slots are physically present as
 			 * standard PCIe slots on the board.
 			 */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			pcie00: pcie@0,0 {
 				status = "okay";
 			};
-			pcie@2,0 {
-				/* Port 0, Lane 1 */
+			pcie01: pcie@0,1 {
 				status = "okay";
 			};
-			pcie@3,0 {
-				/* Port 0, Lane 2 */
+			pcie02: pcie@0,2 {
 				status = "okay";
 			};
-			pcie@4,0 {
-				/* Port 0, Lane 3 */
+			pcie03: pcie@0,3 {
 				status = "okay";
 			};
-			pcie@9,0 {
-				/* Port 2, Lane 0 */
+			pcie20: pcie@2,0 {
 				status = "okay";
 			};
-			pcie@10,0 {
-				/* Port 3, Lane 0 */
+			pcie30: pcie@3,0 {
 				status = "okay";
 			};
 		};
diff --git a/arch/arm/boot/dts/armada-xp-gp.dts b/arch/arm/boot/dts/armada-xp-gp.dts
index 0478c55ca656..30435e85ff33 100644
--- a/arch/arm/boot/dts/armada-xp-gp.dts
+++ b/arch/arm/boot/dts/armada-xp-gp.dts
@@ -81,23 +81,20 @@
 			};
 		};
 
-		pcie-controller {
+		pcie: pcie-controller {
 			status = "okay";
 
 			/*
 			 * The 3 slots are physically present as
 			 * standard PCIe slots on the board.
 			 */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			pcie00: pcie@0,0 {
 				status = "okay";
 			};
-			pcie@9,0 {
-				/* Port 2, Lane 0 */
+			pcie20: pcie@2,0 {
 				status = "okay";
 			};
-			pcie@10,0 {
-				/* Port 3, Lane 0 */
+			pcie30: pcie@3,0 {
 				status = "okay";
 			};
 		};
diff --git a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
index 90d9002923f5..d7607009ecdc 100644
--- a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
+++ b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
@@ -34,18 +34,16 @@
 		ranges = <MBUS_ID(0xf0, 0x01) 0 0 0xd0000000 0x100000
 			MBUS_ID(0x01, 0x1d) 0 0 0xfff00000 0x100000>;
 
-		pcie-controller {
+		pcie: pcie-controller {
 			status = "okay";
 
 			/* Quad port sata: Marvell 88SX7042 */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			pcie00: pcie@0,0 {
 				status = "okay";
 			};
 
 			/* USB 3.0 xHCI controller: NEC D720200F1 */
-			pcie@5,0 {
-				/* Port 1, Lane 0 */
+			pcie10: pcie@1,0 {
 				status = "okay";
 			};
 		};
diff --git a/arch/arm/boot/dts/armada-xp-matrix.dts b/arch/arm/boot/dts/armada-xp-matrix.dts
index 7e291e2ef4b3..77f9f01a9920 100644
--- a/arch/arm/boot/dts/armada-xp-matrix.dts
+++ b/arch/arm/boot/dts/armada-xp-matrix.dts
@@ -63,11 +63,10 @@
 				};
 			};
 
-			pcie-controller {
+			pcie: pcie-controller {
 				status = "okay";
 
-				pcie@1,0 {
-					/* Port 0, Lane 0 */
+				pcie00: pcie@0,0 {
 					status = "okay";
 				};
 			};
diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index 281ccd24295c..ab10499bac3e 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -52,7 +52,7 @@
 		 * configured as x4 or quad x1 lanes. One unit is
 		 * x1 only.
 		 */
-		pcie-controller {
+		pcie: pcie-controller {
 			compatible = "marvell,armada-xp-pcie";
 			status = "disabled";
 			device_type = "pci";
@@ -80,7 +80,7 @@
 				0x82000000 0x5 0       MBUS_ID(0x08, 0xe8) 0 1 0 /* Port 1.0 MEM */
 				0x81000000 0x5 0       MBUS_ID(0x08, 0xe0) 0 1 0 /* Port 1.0 IO  */>;
 
-			pcie@1,0 {
+			pcie00: pcie@0,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
 				reg = <0x0800 0 0 0 0>;
@@ -97,7 +97,7 @@
 				status = "disabled";
 			};
 
-			pcie@2,0 {
+			pcie01: pcie@0,1 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
@@ -114,7 +114,7 @@
 				status = "disabled";
 			};
 
-			pcie@3,0 {
+			pcie02: pcie@0,2 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
@@ -131,7 +131,7 @@
 				status = "disabled";
 			};
 
-			pcie@4,0 {
+			pcie03: pcie@0,3 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
@@ -148,7 +148,7 @@
 				status = "disabled";
 			};
 
-			pcie@5,0 {
+			pcie10: pcie@1,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x80000 0 0x2000>;
 				reg = <0x2800 0 0 0 0>;
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index d7a8d0b0f385..ac0c3918686d 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -54,7 +54,7 @@
 		 * configured as x4 or quad x1 lanes. One unit is
 		 * x4 only.
 		 */
-		pcie-controller {
+		pcie: pcie-controller {
 			compatible = "marvell,armada-xp-pcie";
 			status = "disabled";
 			device_type = "pci";
@@ -96,7 +96,7 @@
 				0x82000000 0x9 0     MBUS_ID(0x04, 0xf8) 0 1 0 /* Port 2.0 MEM */
 				0x81000000 0x9 0     MBUS_ID(0x04, 0xf0) 0 1 0 /* Port 2.0 IO  */>;
 
-			pcie@1,0 {
+			pcie00: pcie@0,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
 				reg = <0x0800 0 0 0 0>;
@@ -113,7 +113,7 @@
 				status = "disabled";
 			};
 
-			pcie@2,0 {
+			pcie01: pcie@0,1 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
@@ -130,7 +130,7 @@
 				status = "disabled";
 			};
 
-			pcie@3,0 {
+			pcie02: pcie@0,2 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
@@ -147,7 +147,7 @@
 				status = "disabled";
 			};
 
-			pcie@4,0 {
+			pcie03: pcie@0,3 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
@@ -164,7 +164,7 @@
 				status = "disabled";
 			};
 
-			pcie@5,0 {
+			pcie10: pcie@1,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x80000 0 0x2000>;
 				reg = <0x2800 0 0 0 0>;
@@ -181,7 +181,7 @@
 				status = "disabled";
 			};
 
-			pcie@6,0 {
+			pcie11: pcie@1,1 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x84000 0 0x2000>;
 				reg = <0x3000 0 0 0 0>;
@@ -198,7 +198,7 @@
 				status = "disabled";
 			};
 
-			pcie@7,0 {
+			pcie12: pcie@1,2 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x88000 0 0x2000>;
 				reg = <0x3800 0 0 0 0>;
@@ -215,7 +215,7 @@
 				status = "disabled";
 			};
 
-			pcie@8,0 {
+			pcie13: pcie@1,3 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x8c000 0 0x2000>;
 				reg = <0x4000 0 0 0 0>;
@@ -232,7 +232,7 @@
 				status = "disabled";
 			};
 
-			pcie@9,0 {
+			pcie20: pcie@2,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
 				reg = <0x4800 0 0 0 0>;
diff --git a/arch/arm/boot/dts/armada-xp-mv78460.dtsi b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
index 9c40c130d11a..18f904ac13c5 100644
--- a/arch/arm/boot/dts/armada-xp-mv78460.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
@@ -71,7 +71,7 @@
 		 * configured as x4 or quad x1 lanes. Two units are
 		 * x4/x1.
 		 */
-		pcie-controller {
+		pcie: pcie-controller {
 			compatible = "marvell,armada-xp-pcie";
 			status = "disabled";
 			device_type = "pci";
@@ -117,7 +117,7 @@
 				0x82000000 0xa 0     MBUS_ID(0x08, 0xf8) 0 1 0 /* Port 3.0 MEM */
 				0x81000000 0xa 0     MBUS_ID(0x08, 0xf0) 0 1 0 /* Port 3.0 IO  */>;
 
-			pcie@1,0 {
+			pcie00: pcie@0,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
 				reg = <0x0800 0 0 0 0>;
@@ -134,7 +134,7 @@
 				status = "disabled";
 			};
 
-			pcie@2,0 {
+			pcie01: pcie@0,1 {
 				device_type = "pci";
 				assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
@@ -151,7 +151,7 @@
 				status = "disabled";
 			};
 
-			pcie@3,0 {
+			pcie02: pcie@0,2 {
 				device_type = "pci";
 				assigned-addresses = <0x82001800 0 0x48000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
@@ -168,7 +168,7 @@
 				status = "disabled";
 			};
 
-			pcie@4,0 {
+			pcie03: pcie@0,3 {
 				device_type = "pci";
 				assigned-addresses = <0x82002000 0 0x4c000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
@@ -185,7 +185,7 @@
 				status = "disabled";
 			};
 
-			pcie@5,0 {
+			pcie10: pcie@1,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
 				reg = <0x2800 0 0 0 0>;
@@ -202,7 +202,7 @@
 				status = "disabled";
 			};
 
-			pcie@6,0 {
+			pcie11: pcie@1,1 {
 				device_type = "pci";
 				assigned-addresses = <0x82003000 0 0x84000 0 0x2000>;
 				reg = <0x3000 0 0 0 0>;
@@ -219,7 +219,7 @@
 				status = "disabled";
 			};
 
-			pcie@7,0 {
+			pcie12: pcie@1,2 {
 				device_type = "pci";
 				assigned-addresses = <0x82003800 0 0x88000 0 0x2000>;
 				reg = <0x3800 0 0 0 0>;
@@ -236,7 +236,7 @@
 				status = "disabled";
 			};
 
-			pcie@8,0 {
+			pcie13: pcie@1,3 {
 				device_type = "pci";
 				assigned-addresses = <0x82004000 0 0x8c000 0 0x2000>;
 				reg = <0x4000 0 0 0 0>;
@@ -253,7 +253,7 @@
 				status = "disabled";
 			};
 
-			pcie@9,0 {
+			pcie20: pcie@2,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82004800 0 0x42000 0 0x2000>;
 				reg = <0x4800 0 0 0 0>;
@@ -270,7 +270,7 @@
 				status = "disabled";
 			};
 
-			pcie@10,0 {
+			pcie30: pcie@3,0 {
 				device_type = "pci";
 				assigned-addresses = <0x82005000 0 0x82000 0 0x2000>;
 				reg = <0x5000 0 0 0 0>;
diff --git a/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts b/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
index 8c241d08f2a3..98beb572a46c 100644
--- a/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
+++ b/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
@@ -32,24 +32,21 @@
 		ranges = <MBUS_ID(0xf0, 0x01) 0 0 0xd0000000 0x100000
 			  MBUS_ID(0x01, 0x1d) 0 0 0xfff00000 0x100000>;
 
-		pcie-controller {
+		pcie: pcie-controller {
 			status = "okay";
 
 			/* Connected to first Marvell 88SE9170 SATA controller */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			pcie00: pcie@0,0 {
 				status = "okay";
 			};
 
 			/* Connected to second Marvell 88SE9170 SATA controller */
-			pcie@2,0 {
-				/* Port 0, Lane 1 */
+			pcie01: pcie@0,1 {
 				status = "okay";
 			};
 
 			/* Connected to Fresco Logic FL1009 USB 3.0 controller */
-			pcie@5,0 {
-				/* Port 1, Lane 0 */
+			pcie10: pcie@1,0 {
 				status = "okay";
 			};
 		};
diff --git a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
index 6f6b0916df48..781818614adc 100644
--- a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
+++ b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
@@ -61,11 +61,10 @@
 			};
 		};
 
-		pcie-controller {
+		pcie: pcie-controller {
 			status = "okay";
 			/* Internal mini-PCIe connector */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			pcie00: pcie@0,0 {
 				status = "okay";
 			};
 		};
-- 
2.0.0

