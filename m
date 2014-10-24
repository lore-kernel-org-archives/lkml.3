Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaJXPYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:24:33 -0400
Received: from down.free-electrons.com ([37.187.137.238]:40659 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756733AbaJXPY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:24:29 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: "Kishon Vijay Abraham I" <kishon@ti.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] Phy: DT binding documentation for Marvell MVEBU SATA phy.
Date: Fri, 24 Oct 2014 17:24:10 +0200
Message-Id: <1414164254-13053-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com>
References: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

Describe the binding for the Marvell MVEBU SATA phy. This driver
can be used at least with Kirkwood, Dove and maybe others.
Additionally, update the SATA binding with the properties to link
to the phy nodes.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/devicetree/bindings/ata/marvell.txt  |  6 ++++++
 .../devicetree/bindings/phy/phy-mvebu.txt          | 22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-mvebu.txt

diff --git a/Documentation/devicetree/bindings/ata/marvell.txt b/Documentation/devicetree/bindings/ata/marvell.txt
index 1c8351604d38..b460edd12766 100644
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
index 000000000000..6cb3364aeafb
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
1.9.1

