Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3LJIBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:01:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3LJIBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnaud Ebalard <arno@natisbad.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.12 20/62] ARM: mvebu: fix second and third PCIe unit of Armada XP mv78260
Date: Tue, 10 Dec 2013 00:00:51 -0800
Message-Id: <20131210080058.847345640@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Ebalard <arno@natisbad.org>

commit 2163e61c92d9337e721a0d067d88ae62b52e0d3e upstream.

mv78260 flavour of Marvell Armada XP SoC has 3 PCIe units. The
two first units are both x4 and quad x1 capable. The third unit
is only x4 capable. This patch fixes mv78260 .dtsi to reflect
those capabilities.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/armada-xp-mv78260.dtsi |  109 ++++++++++++++++++++++++-------
 1 file changed, 85 insertions(+), 24 deletions(-)

--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -48,7 +48,7 @@
 		/*
 		 * MV78260 has 3 PCIe units Gen2.0: Two units can be
 		 * configured as x4 or quad x1 lanes. One unit is
-		 * x4/x1.
+		 * x4 only.
 		 */
 		pcie-controller {
 			compatible = "marvell,armada-xp-pcie";
@@ -67,7 +67,9 @@
 				0x82000000 0 0x48000 MBUS_ID(0xf0, 0x01) 0x48000 0 0x00002000   /* Port 0.2 registers */
 				0x82000000 0 0x4c000 MBUS_ID(0xf0, 0x01) 0x4c000 0 0x00002000   /* Port 0.3 registers */
 				0x82000000 0 0x80000 MBUS_ID(0xf0, 0x01) 0x80000 0 0x00002000   /* Port 1.0 registers */
-				0x82000000 0 0x82000 MBUS_ID(0xf0, 0x01) 0x82000 0 0x00002000   /* Port 3.0 registers */
+				0x82000000 0 0x84000 MBUS_ID(0xf0, 0x01) 0x84000 0 0x00002000   /* Port 1.1 registers */
+				0x82000000 0 0x88000 MBUS_ID(0xf0, 0x01) 0x88000 0 0x00002000   /* Port 1.2 registers */
+				0x82000000 0 0x8c000 MBUS_ID(0xf0, 0x01) 0x8c000 0 0x00002000   /* Port 1.3 registers */
 				0x82000000 0x1 0     MBUS_ID(0x04, 0xe8) 0 1 0 /* Port 0.0 MEM */
 				0x81000000 0x1 0     MBUS_ID(0x04, 0xe0) 0 1 0 /* Port 0.0 IO  */
 				0x82000000 0x2 0     MBUS_ID(0x04, 0xd8) 0 1 0 /* Port 0.1 MEM */
@@ -76,10 +78,18 @@
 				0x81000000 0x3 0     MBUS_ID(0x04, 0xb0) 0 1 0 /* Port 0.2 IO  */
 				0x82000000 0x4 0     MBUS_ID(0x04, 0x78) 0 1 0 /* Port 0.3 MEM */
 				0x81000000 0x4 0     MBUS_ID(0x04, 0x70) 0 1 0 /* Port 0.3 IO  */
-				0x82000000 0x9 0     MBUS_ID(0x08, 0xe8) 0 1 0 /* Port 1.0 MEM */
-				0x81000000 0x9 0     MBUS_ID(0x08, 0xe0) 0 1 0 /* Port 1.0 IO  */
-				0x82000000 0xa 0     MBUS_ID(0x08, 0xf8) 0 1 0 /* Port 3.0 MEM */
-				0x81000000 0xa 0     MBUS_ID(0x08, 0xf0) 0 1 0 /* Port 3.0 IO  */>;
+
+				0x82000000 0x5 0     MBUS_ID(0x08, 0xe8) 0 1 0 /* Port 1.0 MEM */
+				0x81000000 0x5 0     MBUS_ID(0x08, 0xe0) 0 1 0 /* Port 1.0 IO  */
+				0x82000000 0x6 0     MBUS_ID(0x08, 0xd8) 0 1 0 /* Port 1.1 MEM */
+				0x81000000 0x6 0     MBUS_ID(0x08, 0xd0) 0 1 0 /* Port 1.1 IO  */
+				0x82000000 0x7 0     MBUS_ID(0x08, 0xb8) 0 1 0 /* Port 1.2 MEM */
+				0x81000000 0x7 0     MBUS_ID(0x08, 0xb0) 0 1 0 /* Port 1.2 IO  */
+				0x82000000 0x8 0     MBUS_ID(0x08, 0x78) 0 1 0 /* Port 1.3 MEM */
+				0x81000000 0x8 0     MBUS_ID(0x08, 0x70) 0 1 0 /* Port 1.3 IO  */
+
+				0x82000000 0x9 0     MBUS_ID(0x04, 0xf8) 0 1 0 /* Port 2.0 MEM */
+				0x81000000 0x9 0     MBUS_ID(0x04, 0xf0) 0 1 0 /* Port 2.0 IO  */>;
 
 			pcie@1,0 {
 				device_type = "pci";
@@ -105,8 +115,8 @@
 				#address-cells = <3>;
 				#size-cells = <2>;
 				#interrupt-cells = <1>;
-                                ranges = <0x82000000 0 0 0x82000000 0x2 0 1 0
-                                          0x81000000 0 0 0x81000000 0x2 0 1 0>;
+				ranges = <0x82000000 0 0 0x82000000 0x2 0 1 0
+					  0x81000000 0 0 0x81000000 0x2 0 1 0>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &mpic 59>;
 				marvell,pcie-port = <0>;
@@ -149,37 +159,88 @@
 				status = "disabled";
 			};
 
-			pcie@9,0 {
+			pcie@5,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
-				reg = <0x4800 0 0 0 0>;
+				assigned-addresses = <0x82000800 0 0x80000 0 0x2000>;
+				reg = <0x2800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
 				#interrupt-cells = <1>;
-				ranges = <0x82000000 0 0 0x82000000 0x9 0 1 0
-					  0x81000000 0 0 0x81000000 0x9 0 1 0>;
+				ranges = <0x82000000 0 0 0x82000000 0x5 0 1 0
+					  0x81000000 0 0 0x81000000 0x5 0 1 0>;
 				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 99>;
-				marvell,pcie-port = <2>;
+				interrupt-map = <0 0 0 0 &mpic 62>;
+				marvell,pcie-port = <1>;
 				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 26>;
+				clocks = <&gateclk 9>;
 				status = "disabled";
 			};
 
-			pcie@10,0 {
+			pcie@6,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x82000 0 0x2000>;
-				reg = <0x5000 0 0 0 0>;
+				assigned-addresses = <0x82000800 0 0x84000 0 0x2000>;
+				reg = <0x3000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
 				#interrupt-cells = <1>;
-				ranges = <0x82000000 0 0 0x82000000 0xa 0 1 0
-					  0x81000000 0 0 0x81000000 0xa 0 1 0>;
+				ranges = <0x82000000 0 0 0x82000000 0x6 0 1 0
+					  0x81000000 0 0 0x81000000 0x6 0 1 0>;
 				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 103>;
-				marvell,pcie-port = <3>;
+				interrupt-map = <0 0 0 0 &mpic 63>;
+				marvell,pcie-port = <1>;
+				marvell,pcie-lane = <1>;
+				clocks = <&gateclk 10>;
+				status = "disabled";
+			};
+
+			pcie@7,0 {
+				device_type = "pci";
+				assigned-addresses = <0x82000800 0 0x88000 0 0x2000>;
+				reg = <0x3800 0 0 0 0>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				#interrupt-cells = <1>;
+				ranges = <0x82000000 0 0 0x82000000 0x7 0 1 0
+					  0x81000000 0 0 0x81000000 0x7 0 1 0>;
+				interrupt-map-mask = <0 0 0 0>;
+				interrupt-map = <0 0 0 0 &mpic 64>;
+				marvell,pcie-port = <1>;
+				marvell,pcie-lane = <2>;
+				clocks = <&gateclk 11>;
+				status = "disabled";
+			};
+
+			pcie@8,0 {
+				device_type = "pci";
+				assigned-addresses = <0x82000800 0 0x8c000 0 0x2000>;
+				reg = <0x4000 0 0 0 0>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				#interrupt-cells = <1>;
+				ranges = <0x82000000 0 0 0x82000000 0x8 0 1 0
+					  0x81000000 0 0 0x81000000 0x8 0 1 0>;
+				interrupt-map-mask = <0 0 0 0>;
+				interrupt-map = <0 0 0 0 &mpic 65>;
+				marvell,pcie-port = <1>;
+				marvell,pcie-lane = <3>;
+				clocks = <&gateclk 12>;
+				status = "disabled";
+			};
+
+			pcie@9,0 {
+				device_type = "pci";
+				assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
+				reg = <0x4800 0 0 0 0>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				#interrupt-cells = <1>;
+				ranges = <0x82000000 0 0 0x82000000 0x9 0 1 0
+					  0x81000000 0 0 0x81000000 0x9 0 1 0>;
+				interrupt-map-mask = <0 0 0 0>;
+				interrupt-map = <0 0 0 0 &mpic 99>;
+				marvell,pcie-port = <2>;
 				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 27>;
+				clocks = <&gateclk 26>;
 				status = "disabled";
 			};
 		};


