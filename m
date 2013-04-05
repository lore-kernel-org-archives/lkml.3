Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162845Ab3DEUYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:24:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40720 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162728Ab3DEUYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:24:33 -0400
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
Subject: [PATCH v2 9/9] arm: dts: mvebu: Convert mvebu device tree files to 64 bits
Date: Fri,  5 Apr 2013 22:24:04 +0200
Message-Id: <1365193444-13441-10-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to use more than 4GB of RAM when the LPAE is
activated, the dts must be converted in 64 bits.

Armada XP and Armada 370 share a dtsi file which have also be
converted to 64 bits. This lead to convert all the device tree files
to 64 bits even the one used for Armada 370 (which don't support LPAE)

This was heavily based on the work of Lior Amsalem.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-370-db.dts              |    2 +-
 arch/arm/boot/dts/armada-370-mirabox.dts         |    2 +-
 arch/arm/boot/dts/armada-370-rd.dts              |    2 +-
 arch/arm/boot/dts/armada-370-xp.dtsi             |    4 ++--
 arch/arm/boot/dts/armada-xp-db.dts               |    2 +-
 arch/arm/boot/dts/armada-xp-gp.dts               |   14 ++++++++------
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |    2 +-
 7 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/armada-370-db.dts b/arch/arm/boot/dts/armada-370-db.dts
index 6c30a9f..c996c06 100644
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
index 5a06e87..29b6b64 100644
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
index 437dcd2..09e75fc 100644
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
index 8b9adc6..6a3b418 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -16,7 +16,7 @@
  * 370 and Armada XP SoC.
  */
 
-/include/ "skeleton.dtsi"
+/include/ "skeleton64.dtsi"
 
 / {
 	model = "Marvell Armada 370 and XP SoC";
@@ -33,7 +33,7 @@
 		#size-cells = <1>;
 		compatible = "simple-bus";
 		interrupt-parent = <&mpic>;
-		ranges = <0 0xd0000000 0x100000>;
+		ranges = <0 0 0xd0000000 0x100000>;
 
 		internal-regs {
 			compatible = "simple-bus";
diff --git a/arch/arm/boot/dts/armada-xp-db.dts b/arch/arm/boot/dts/armada-xp-db.dts
index fbd0f04..a2dd24e 100644
--- a/arch/arm/boot/dts/armada-xp-db.dts
+++ b/arch/arm/boot/dts/armada-xp-db.dts
@@ -26,7 +26,7 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x80000000>; /* 2 GB */
+		reg = <0 0x00000000 0 0x80000000>; /* 2 GB */
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-xp-gp.dts b/arch/arm/boot/dts/armada-xp-gp.dts
index b0298d7..b022906 100644
--- a/arch/arm/boot/dts/armada-xp-gp.dts
+++ b/arch/arm/boot/dts/armada-xp-gp.dts
@@ -26,14 +26,16 @@
 
 	memory {
 		device_type = "memory";
-
 		/*
-		 * 4 GB of plug-in RAM modules by default but only 3GB
-		 * are visible, the amount of memory available can be
-		 * changed by the bootloader according the size of the
-		 * module actually plugged
+                 * 8 GB of plug-in RAM modules by default.The amount
+                 * of memory available can be changed by the
+                 * bootloader according the size of the module
+                 * actually plugged. Only 7GB are usable because
+                 * addresses from 0xC0000000 to 0xffffffff are used by
+                 * the internal registers of the SoC.
 		 */
-		reg = <0x00000000 0xC0000000>;
+		reg = <0x00000000 0x00000000 0x00000000 0xC0000000>,
+		      <0x00000001 0x00000000 0x00000001 0x00000000>;
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
index e2eaf4f..1f274e7 100644
--- a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
+++ b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
@@ -23,7 +23,7 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0xC0000000>; /* 3 GB */
+		reg = <0 0x00000000 0 0xC0000000>; /* 3 GB */
 	};
 
 	soc {
-- 
1.7.9.5

