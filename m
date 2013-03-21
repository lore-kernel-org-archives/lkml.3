Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006Ab3CUQ0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:26:36 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54441 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933726Ab3CUQ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:26:33 -0400
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
Subject: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
Date: Thu, 21 Mar 2013 17:26:18 +0100
Message-Id: <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to use more than 4GB of RAM when the LPAE is
activated, the dts must be converted in 64 bits.

Armada XP and Armada 370 share a dtsi file which have also be
converted to 64 bits. This lead to convert all the device tree files
to 64 bits even the one used for Armada 370 (which don't support
LPAE)

This was heavily based on the work of Lior Amsalem.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-370-db.dts              |    2 +-
 arch/arm/boot/dts/armada-370-mirabox.dts         |    2 +-
 arch/arm/boot/dts/armada-370-rd.dts              |    2 +-
 arch/arm/boot/dts/armada-370-xp.dtsi             |   45 +++++++++++-----------
 arch/arm/boot/dts/armada-370.dtsi                |   28 +++++++-------
 arch/arm/boot/dts/armada-xp-db.dts               |    2 +-
 arch/arm/boot/dts/armada-xp-gp.dts               |   14 ++++---
 arch/arm/boot/dts/armada-xp-mv78230.dtsi         |    6 +--
 arch/arm/boot/dts/armada-xp-mv78260.dtsi         |   10 ++---
 arch/arm/boot/dts/armada-xp-mv78460.dtsi         |   10 ++---
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |    2 +-
 arch/arm/boot/dts/armada-xp.dtsi                 |   34 ++++++++--------
 12 files changed, 80 insertions(+), 77 deletions(-)

diff --git a/arch/arm/boot/dts/armada-370-db.dts b/arch/arm/boot/dts/armada-370-db.dts
index e34b280..0bde82c 100644
--- a/arch/arm/boot/dts/armada-370-db.dts
+++ b/arch/arm/boot/dts/armada-370-db.dts
@@ -26,7 +26,7 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x40000000>; /* 1 GB */
+		reg = <0 0x00000000 0 0x40000000>; /* 1 GB */
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-370-mirabox.dts b/arch/arm/boot/dts/armada-370-mirabox.dts
index dd0c57d..fd08cd6 100644
--- a/arch/arm/boot/dts/armada-370-mirabox.dts
+++ b/arch/arm/boot/dts/armada-370-mirabox.dts
@@ -21,7 +21,7 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x20000000>; /* 512 MB */
+		reg = <0 0x00000000 0 0x20000000>; /* 512 MB */
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
index 070bba4..e51948d 100644
--- a/arch/arm/boot/dts/armada-370-rd.dts
+++ b/arch/arm/boot/dts/armada-370-rd.dts
@@ -24,7 +24,7 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x20000000>; /* 512 MB */
+		reg = <0 0x00000000 0 0x20000000>; /* 512 MB */
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 5b70820..562f24c 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -15,8 +15,7 @@
  * This file contains the definitions that are common to the Armada
  * 370 and Armada XP SoC.
  */
-
-/include/ "skeleton.dtsi"
+/include/ "skeleton64.dtsi"
 
 / {
 	model = "Marvell Armada 370 and XP SoC";
@@ -37,20 +36,20 @@
 
 	coherency-fabric@d0020200 {
 		compatible = "marvell,coherency-fabric";
-		reg = <0xd0020200 0xb0>,
-		      <0xd0021810 0x1c>;
+		reg = <0 0xd0020200 0 0xb0>,
+		      <0 0xd0021810 0 0x1c>;
 	};
 
 	soc {
-		#address-cells = <1>;
-		#size-cells = <1>;
+		#address-cells = <2>;
+		#size-cells = <2>;
 		compatible = "simple-bus";
 		interrupt-parent = <&mpic>;
 		ranges;
 
 		serial@d0012000 {
 				compatible = "snps,dw-apb-uart";
-				reg = <0xd0012000 0x100>;
+				reg = <0 0xd0012000 0 0x100>;
 				reg-shift = <2>;
 				interrupts = <41>;
 				reg-io-width = <1>;
@@ -58,7 +57,7 @@
 		};
 		serial@d0012100 {
 				compatible = "snps,dw-apb-uart";
-				reg = <0xd0012100 0x100>;
+				reg = <0 0xd0012100 0 0x100>;
 				reg-shift = <2>;
 				interrupts = <42>;
 				reg-io-width = <1>;
@@ -67,20 +66,20 @@
 
 		timer@d0020300 {
 			       compatible = "marvell,armada-370-xp-timer";
-			       reg = <0xd0020300 0x30>,
-			       <0xd0021040 0x30>;
+			       reg = <0 0xd0020300 0 0x30>,
+			       <0 0xd0021040 0 0x30>;
 			       interrupts = <37>, <38>, <39>, <40>, <5>, <6>;
 			       clocks = <&coreclk 2>;
 		};
 
 		addr-decoding@d0020000 {
 			compatible = "marvell,armada-addr-decoding-controller";
-			reg = <0xd0020000 0x258>;
+			reg = <0 0xd0020000 0 0x258>;
 		};
 
 		sata@d00a0000 {
 			compatible = "marvell,orion-sata";
-			reg = <0xd00a0000 0x2400>;
+			reg = <0 0xd00a0000 0 0x2400>;
 			interrupts = <55>;
 			clocks = <&gateclk 15>, <&gateclk 30>;
 			clock-names = "0", "1";
@@ -91,12 +90,12 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			compatible = "marvell,orion-mdio";
-			reg = <0xd0072004 0x4>;
+			reg = <0 0xd0072004 0 0x4>;
 		};
 
 		ethernet@d0070000 {
 				compatible = "marvell,armada-370-neta";
-				reg = <0xd0070000 0x2500>;
+				reg = <0 0xd0070000 0 0x2500>;
 				interrupts = <8>;
 				clocks = <&gateclk 4>;
 				status = "disabled";
@@ -104,7 +103,7 @@
 
 		ethernet@d0074000 {
 				compatible = "marvell,armada-370-neta";
-				reg = <0xd0074000 0x2500>;
+				reg = <0 0xd0074000 0 0x2500>;
 				interrupts = <10>;
 				clocks = <&gateclk 3>;
 				status = "disabled";
@@ -112,7 +111,7 @@
 
 		i2c0: i2c@d0011000 {
 			compatible = "marvell,mv64xxx-i2c";
-			reg = <0xd0011000 0x20>;
+			reg = <0 0xd0011000 0 0x20>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			interrupts = <31>;
@@ -123,7 +122,7 @@
 
 		i2c1: i2c@d0011100 {
 			compatible = "marvell,mv64xxx-i2c";
-			reg = <0xd0011100 0x20>;
+			reg = <0 0xd0011100 0 0x20>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			interrupts = <32>;
@@ -134,13 +133,13 @@
 
 		rtc@10300 {
 			compatible = "marvell,orion-rtc";
-			reg = <0xd0010300 0x20>;
+			reg = <0 0xd0010300 0 0x20>;
 			interrupts = <50>;
 		};
 
 		mvsdio@d00d4000 {
 			compatible = "marvell,orion-sdio";
-			reg = <0xd00d4000 0x200>;
+			reg = <0 0xd00d4000 0 0x200>;
 			interrupts = <54>;
 			clocks = <&gateclk 17>;
 			status = "disabled";
@@ -148,21 +147,21 @@
 
 		usb@d0050000 {
 			compatible = "marvell,orion-ehci";
-			reg = <0xd0050000 0x500>;
+			reg = <0 0xd0050000 0 0x500>;
 			interrupts = <45>;
 			status = "disabled";
 		};
 
 		usb@d0051000 {
 			compatible = "marvell,orion-ehci";
-			reg = <0xd0051000 0x500>;
+			reg = <0 0xd0051000 0 0x500>;
 			interrupts = <46>;
 			status = "disabled";
 		};
 
 		spi0: spi@d0010600 {
 			compatible = "marvell,orion-spi";
-			reg = <0xd0010600 0x28>;
+			reg = <0 0xd0010600 0 0x28>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			cell-index = <0>;
@@ -173,7 +172,7 @@
 
 		spi1: spi@d0010680 {
 			compatible = "marvell,orion-spi";
-			reg = <0xd0010680 0x28>;
+			reg = <0 0xd0010680 0 0x28>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			cell-index = <1>;
diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index 8188d13..f757880 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -22,7 +22,7 @@
 	compatible = "marvell,armada370", "marvell,armada-370-xp";
 	L2: l2-cache {
 		compatible = "marvell,aurora-outer-cache";
-		reg = <0xd0008000 0x1000>;
+		reg = <0 0xd0008000 0 0x1000>;
 		cache-id-part = <0x100>;
 		wt-override;
 	};
@@ -34,19 +34,19 @@
 	};
 
 	mpic: interrupt-controller@d0020000 {
-	      reg = <0xd0020a00 0x1d0>,
-		    <0xd0021870 0x58>;
+	      reg = <0 0xd0020a00 0 0x1d0>,
+		    <0 0xd0021870 0 0x58>;
 	};
 
 	soc {
 		system-controller@d0018200 {
 				compatible = "marvell,armada-370-xp-system-controller";
-				reg = <0xd0018200 0x100>;
+				reg = <0 0xd0018200 0 0x100>;
 		};
 
 		pinctrl {
 			compatible = "marvell,mv88f6710-pinctrl";
-			reg = <0xd0018000 0x38>;
+			reg = <0 0xd0018000 0 0x38>;
 
 			sdio_pins1: sdio-pins1 {
 			      marvell,pins = "mpp9",  "mpp11", "mpp12",
@@ -63,7 +63,7 @@
 
 		gpio0: gpio@d0018100 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018100 0x40>;
+			reg = <0 0xd0018100 0 0x40>;
 			ngpios = <32>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -74,7 +74,7 @@
 
 		gpio1: gpio@d0018140 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018140 0x40>;
+			reg = <0 0xd0018140 0 0x40>;
 			ngpios = <32>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -85,7 +85,7 @@
 
 		gpio2: gpio@d0018180 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018180 0x40>;
+			reg = <0 0xd0018180 0 0x40>;
 			ngpios = <2>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -96,21 +96,21 @@
 
 		coreclk: mvebu-sar@d0018230 {
 			compatible = "marvell,armada-370-core-clock";
-			reg = <0xd0018230 0x08>;
+			reg = <0 0xd0018230 0 0x08>;
 			#clock-cells = <1>;
 		};
 
 		gateclk: clock-gating-control@d0018220 {
 			compatible = "marvell,armada-370-gating-clock";
-			reg = <0xd0018220 0x4>;
+			reg = <0 0xd0018220 0 0x4>;
 			clocks = <&coreclk 0>;
 			#clock-cells = <1>;
 		};
 
 		xor@d0060800 {
 			compatible = "marvell,orion-xor";
-			reg = <0xd0060800 0x100
-			       0xd0060A00 0x100>;
+			reg = <0 0xd0060800 0 0x100
+			       0 0xd0060A00 0 0x100>;
 			status = "okay";
 
 			xor00 {
@@ -128,8 +128,8 @@
 
 		xor@d0060900 {
 			compatible = "marvell,orion-xor";
-			reg = <0xd0060900 0x100
-			       0xd0060b00 0x100>;
+			reg = <0 0xd0060900 0 0x100
+			       0 0xd0060b00 0 0x100>;
 			status = "okay";
 
 			xor10 {
diff --git a/arch/arm/boot/dts/armada-xp-db.dts b/arch/arm/boot/dts/armada-xp-db.dts
index e83505e..4922f77 100644
--- a/arch/arm/boot/dts/armada-xp-db.dts
+++ b/arch/arm/boot/dts/armada-xp-db.dts
@@ -26,7 +26,7 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x80000000>; /* 2 GB */
+		reg = <0x00000000 0x00000000 0x00000000 0x80000000>; /* 2 GB */
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-xp-gp.dts b/arch/arm/boot/dts/armada-xp-gp.dts
index 1c8afe2..78d9c2a 100644
--- a/arch/arm/boot/dts/armada-xp-gp.dts
+++ b/arch/arm/boot/dts/armada-xp-gp.dts
@@ -28,12 +28,16 @@
 		device_type = "memory";
 
 		/*
-		 * 4 GB of plug-in RAM modules by default but only 3GB
-		 * are visible, the amount of memory available can be
-		 * changed by the bootloader according the size of the
-		 * module actually plugged
+		 * 8 GB of plug-in RAM modules by default.The amount
+		 * of memory available can be changed by the
+		 * bootloader according the size of the module
+		 * actually plugged. Only 7GB are usable because
+		 * addresses from 0xC0000000 to 0xffffffff are used by
+		 * the internal registers of the SoC.
 		 */
-		reg = <0x00000000 0xC0000000>;
+		reg = <0x00000000 0x00000000 0x00000000 0xC0000000>,
+		      <0x00000001 0x00000000 0x00000001 0x00000000>;
+
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index f56c405..23eb8d61 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -46,7 +46,7 @@
 	soc {
 		pinctrl {
 			compatible = "marvell,mv78230-pinctrl";
-			reg = <0xd0018000 0x38>;
+			reg = <0 0xd0018000 0 0x38>;
 
 			sdio_pins: sdio-pins {
 				marvell,pins = "mpp30", "mpp31", "mpp32",
@@ -57,7 +57,7 @@
 
 		gpio0: gpio@d0018100 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018100 0x40>;
+			reg = <0 0xd0018100 0 0x40>;
 			ngpios = <32>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -68,7 +68,7 @@
 
 		gpio1: gpio@d0018140 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018140 0x40>;
+			reg = <0 0xd0018140 0 0x40>;
 			ngpios = <17>;
 			gpio-controller;
 			#gpio-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index f8f2b78..b2b0f45 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -47,7 +47,7 @@
 	soc {
 		pinctrl {
 			compatible = "marvell,mv78260-pinctrl";
-			reg = <0xd0018000 0x38>;
+			reg = <0 0xd0018000 0 0x38>;
 
 			sdio_pins: sdio-pins {
 				marvell,pins = "mpp30", "mpp31", "mpp32",
@@ -58,7 +58,7 @@
 
 		gpio0: gpio@d0018100 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018100 0x40>;
+			reg = <0 0xd0018100 0 0x40>;
 			ngpios = <32>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -69,7 +69,7 @@
 
 		gpio1: gpio@d0018140 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018140 0x40>;
+			reg = <0 0xd0018140 0 0x40>;
 			ngpios = <32>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -80,7 +80,7 @@
 
 		gpio2: gpio@d0018180 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018180 0x40>;
+			reg = <0 0xd0018180 0 0x40>;
 			ngpios = <3>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -91,7 +91,7 @@
 
 		ethernet@d0034000 {
 				compatible = "marvell,armada-370-neta";
-				reg = <0xd0034000 0x2500>;
+				reg = <0 0xd0034000 0 0x2500>;
 				interrupts = <14>;
 				clocks = <&gateclk 1>;
 				status = "disabled";
diff --git a/arch/arm/boot/dts/armada-xp-mv78460.dtsi b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
index 936c25d..4de33c2 100644
--- a/arch/arm/boot/dts/armada-xp-mv78460.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
@@ -62,7 +62,7 @@
 	soc {
 		pinctrl {
 			compatible = "marvell,mv78460-pinctrl";
-			reg = <0xd0018000 0x38>;
+			reg = <0 0xd0018000 0 0x38>;
 
 			sdio_pins: sdio-pins {
 				marvell,pins = "mpp30", "mpp31", "mpp32",
@@ -73,7 +73,7 @@
 
 		gpio0: gpio@d0018100 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018100 0x40>;
+			reg = <0 0xd0018100 0 0x40>;
 			ngpios = <32>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -84,7 +84,7 @@
 
 		gpio1: gpio@d0018140 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018140 0x40>;
+			reg = <0 0xd0018140 0 0x40>;
 			ngpios = <32>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -95,7 +95,7 @@
 
 		gpio2: gpio@d0018180 {
 			compatible = "marvell,orion-gpio";
-			reg = <0xd0018180 0x40>;
+			reg = <0 0xd0018180 0 0x40>;
 			ngpios = <3>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -106,7 +106,7 @@
 
 		ethernet@d0034000 {
 				compatible = "marvell,armada-370-neta";
-				reg = <0xd0034000 0x2500>;
+				reg = <0 0xd0034000 0 0x2500>;
 				interrupts = <14>;
 				clocks = <&gateclk 1>;
 				status = "disabled";
diff --git a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
index 3818a82..4b30f26 100644
--- a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
+++ b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
@@ -23,7 +23,7 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0xC0000000>; /* 3 GB */
+		reg = <0x00000000 0x00000000 0x00000000 0xC0000000>; /* 3 GB */
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index ca00d83..5f8d6fc 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -24,26 +24,26 @@
 
 	L2: l2-cache {
 		compatible = "marvell,aurora-system-cache";
-		reg = <0xd0008000 0x1000>;
+		reg = <0 0xd0008000 0 0x1000>;
 		cache-id-part = <0x100>;
 		wt-override;
 	};
 
 	mpic: interrupt-controller@d0020000 {
-	      reg = <0xd0020a00 0x2d0>,
-		    <0xd0021070 0x58>;
+	      reg = <0 0xd0020a00 0 0x2d0>,
+		    <0 0xd0021070 0 0x58>;
 	};
 
 	armada-370-xp-pmsu@d0022000 {
 		compatible = "marvell,armada-370-xp-pmsu";
-		reg = <0xd0022100 0x430>,
-		      <0xd0020800 0x20>;
+		reg = <0 0xd0022100 0 0x430>,
+		      <0 0xd0020800 0 0x20>;
 	};
 
 	soc {
 		serial@d0012200 {
 				compatible = "snps,dw-apb-uart";
-				reg = <0xd0012200 0x100>;
+				reg = <0 0xd0012200 0 0x100>;
 				reg-shift = <2>;
 				interrupts = <43>;
 				reg-io-width = <1>;
@@ -51,7 +51,7 @@
 		};
 		serial@d0012300 {
 				compatible = "snps,dw-apb-uart";
-				reg = <0xd0012300 0x100>;
+				reg = <0 0xd0012300 0 0x100>;
 				reg-shift = <2>;
 				interrupts = <44>;
 				reg-io-width = <1>;
@@ -64,32 +64,32 @@
 
 		coreclk: mvebu-sar@d0018230 {
 			compatible = "marvell,armada-xp-core-clock";
-			reg = <0xd0018230 0x08>;
+			reg = <0 0xd0018230 0 0x08>;
 			#clock-cells = <1>;
 		};
 
 		cpuclk: clock-complex@d0018700 {
 			#clock-cells = <1>;
 			compatible = "marvell,armada-xp-cpu-clock";
-			reg = <0xd0018700 0xA0>;
+			reg = <0 0xd0018700 0 0xA0>;
 			clocks = <&coreclk 1>;
 		};
 
 		gateclk: clock-gating-control@d0018220 {
 			compatible = "marvell,armada-xp-gating-clock";
-			reg = <0xd0018220 0x4>;
+			reg = <0 0xd0018220 0 0x4>;
 			clocks = <&coreclk 0>;
 			#clock-cells = <1>;
 		};
 
 		system-controller@d0018200 {
 				compatible = "marvell,armada-370-xp-system-controller";
-				reg = <0xd0018200 0x500>;
+				reg = <0 0xd0018200 0 0x500>;
 		};
 
 		ethernet@d0030000 {
 				compatible = "marvell,armada-370-neta";
-				reg = <0xd0030000 0x2500>;
+				reg = <0 0xd0030000 0 0x2500>;
 				interrupts = <12>;
 				clocks = <&gateclk 2>;
 				status = "disabled";
@@ -97,8 +97,8 @@
 
 		xor@d0060900 {
 			compatible = "marvell,orion-xor";
-			reg = <0xd0060900 0x100
-			       0xd0060b00 0x100>;
+			reg = <0 0xd0060900 0 0x100
+			       0 0xd0060b00 0 0x100>;
 			clocks = <&gateclk 22>;
 			status = "okay";
 
@@ -117,8 +117,8 @@
 
 		xor@d00f0900 {
 			compatible = "marvell,orion-xor";
-			reg = <0xd00F0900 0x100
-			       0xd00F0B00 0x100>;
+			reg = <0 0xd00F0900 0 0x100
+			       0 0xd00F0B00 0 0x100>;
 			clocks = <&gateclk 28>;
 			status = "okay";
 
@@ -145,7 +145,7 @@
 
 		usb@d0052000 {
 			compatible = "marvell,orion-ehci";
-			reg = <0xd0052000 0x500>;
+			reg = <0 0xd0052000 0 0x500>;
 			interrupts = <47>;
 			clocks = <&gateclk 20>;
 			status = "disabled";
-- 
1.7.9.5

