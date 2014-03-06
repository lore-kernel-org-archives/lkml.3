Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaCFPST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:18:19 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57056 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752594AbaCFPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:18:16 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: mvebu: add Device Tree for the Armada 385 RD board
Date: Thu,  6 Mar 2014 16:17:55 +0100
Message-Id: <1394119075-18657-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Armada 385 RD board is the reference design board from Marvell
for the Armada 385 SoC. This commit adds a Device Tree description for
this board, which enables the following features:

 * Network interfaces
 * I2C bus
 * Serial port
 * SPI bus, with a SPI flash
 * PCIe interface

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
Changelog:
v1 -> v2:

- used the phy-mode "rgmii-id" to be able to work with the Marvell PHY
  driver enabled

- put the ethernet nodes in the address order, as it has no effect to
  change ti at this level (should be done at dtsi level)

- inverted the phy devices (which was improperly assigned in v1)

- added the vendor prefix for the SPI flash


 arch/arm/boot/dts/Makefile          |  3 +-
 arch/arm/boot/dts/armada-385-rd.dts | 94 +++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/armada-385-rd.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 7407ee8961cf..670897b9e915 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -153,7 +153,8 @@ dtb-$(CONFIG_MACH_ARMADA_370) += \
 dtb-$(CONFIG_MACH_ARMADA_375) += \
 	armada-375-db.dtb
 dtb-$(CONFIG_MACH_ARMADA_38X) += \
-	armada-385-db.dtb
+	armada-385-db.dtb \
+	armada-385-rd.dtb
 dtb-$(CONFIG_MACH_ARMADA_XP) += \
 	armada-xp-axpwifiap.dtb \
 	armada-xp-db.dtb \
diff --git a/arch/arm/boot/dts/armada-385-rd.dts b/arch/arm/boot/dts/armada-385-rd.dts
new file mode 100644
index 000000000000..45250c88814b
--- /dev/null
+++ b/arch/arm/boot/dts/armada-385-rd.dts
@@ -0,0 +1,94 @@
+/*
+ * Device Tree file for Marvell Armada 385 Reference Design board
+ * (RD-88F6820-AP)
+ *
+ *  Copyright (C) 2014 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ * Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+/dts-v1/;
+#include "armada-385.dtsi"
+
+/ {
+	model = "Marvell Armada 385 Reference Design";
+	compatible = "marvell,a385-rd", "marvell,armada385", "marvell,armada38x";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>; /* 256 MB */
+	};
+
+	soc {
+		ranges = <MBUS_ID(0xf0, 0x01) 0 0xf1000000 0x100000
+			  MBUS_ID(0x01, 0x1d) 0 0xfff00000 0x100000>;
+
+		internal-regs {
+			spi@10600 {
+				status = "okay";
+
+				spi-flash@0 {
+					#address-cells = <1>;
+					#size-cells = <1>;
+					compatible = "st,m25p128";
+					reg = <0>; /* Chip select 0 */
+					spi-max-frequency = <108000000>;
+				};
+			};
+
+			i2c@11000 {
+				status = "okay";
+				clock-frequency = <100000>;
+			};
+
+			serial@12000 {
+				clock-frequency = <200000000>;
+				status = "okay";
+			};
+
+			ethernet@30000 {
+				status = "okay";
+				phy = <&phy0>;
+				phy-mode = "rgmii-id";
+			};
+
+			ethernet@70000 {
+				status = "okay";
+				phy = <&phy1>;
+				phy-mode = "rgmii-id";
+			};
+
+
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
+
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
+			};
+		};
+
+		pcie-controller {
+			status = "okay";
+			/*
+			 * One PCIe units is accessible through
+			 * standard PCIe slot on the board.
+			 */
+			pcie@1,0 {
+				/* Port 0, Lane 0 */
+				status = "okay";
+			};
+		};
+	};
+};
-- 
1.8.1.2

