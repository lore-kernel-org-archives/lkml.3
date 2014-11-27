Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaK0G2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:28:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41720 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbaK0G0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:55 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/25] Phy: DT binding documentation for Marvell MVEBU SATA phy.
Date: Thu, 27 Nov 2014 11:56:15 +0530
Message-ID: <1417069577-1169-24-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

Describe the binding for the Marvell MVEBU SATA phy. This driver
can be used at least with Kirkwood, Dove and maybe others.
Additionally, update the SATA binding with the properties to link
to the phy nodes.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/ata/marvell.txt  |    6 ++++++
 .../devicetree/bindings/phy/phy-mvebu.txt          |   22 ++++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-mvebu.txt

diff --git a/Documentation/devicetree/bindings/ata/marvell.txt b/Documentation/devicetree/bindings/ata/marvell.txt
index 1c83516..b460edd 100644
--- a/Documentation/devicetree/bindings/ata/marvell.txt
+++ b/Documentation/devicetree/bindings/ata/marvell.txt
@@ -6,11 +6,17 @@ Required Properties:
 - interrupts    : Interrupt controller is using
 - nr-ports      : Number of SATA ports in use.
 
+Optional Properties:
+- phys		: List of phandles to sata phys
+- phy-names	: Should be "0", "1", etc, one number per phandle
+
 Example:
 
 	sata@80000 {
 		compatible = "marvell,orion-sata";
 		reg = <0x80000 0x5000>;
 		interrupts = <21>;
+		phys = <&sata_phy0>, <&sata_phy1>;
+		phy-names = "0", "1";
 		nr-ports = <2>;
 	}
diff --git a/Documentation/devicetree/bindings/phy/phy-mvebu.txt b/Documentation/devicetree/bindings/phy/phy-mvebu.txt
new file mode 100644
index 0000000..6cb3364
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-mvebu.txt
@@ -0,0 +1,22 @@
+* Marvell MVEBU SATA PHY
+
+Power control for the SATA phy found on Marvell MVEBU SoCs.
+
+This document extends the binding described in phy-bindings.txt
+
+Required properties :
+
+ - reg		   : Offset and length of the register set for the SATA device
+ - compatible	   : Should be "marvell,mvebu-sata-phy"
+ - clocks	   : phandle of clock and specifier that supplies the device
+ - clock-names	   : Should be "sata"
+
+Example:
+		sata-phy@84000 {
+			compatible = "marvell,mvebu-sata-phy";
+			reg = <0x84000 0x0334>;
+			clocks = <&gate_clk 15>;
+			clock-names = "sata";
+			#phy-cells = <0>;
+			status = "ok";
+		};
-- 
1.7.9.5

