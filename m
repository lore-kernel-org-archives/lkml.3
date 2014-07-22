Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaGVK5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:57:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43851 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbaGVK5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:41 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/28] Documentation: bindings: add the Berlin SATA PHY
Date: Tue, 22 Jul 2014 16:26:43 +0530
Message-ID: <1406026611-30493-21-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Ténart <antoine.tenart@free-electrons.com>

The Berlin SATA PHY drives the PHY related to the SATA interface. Add
the corresponding documentation.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |   34 ++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
new file mode 100644
index 0000000..88f8c23
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
@@ -0,0 +1,34 @@
+Berlin SATA PHY
+---------------
+
+Required properties:
+- compatible: should be "marvell,berlin2q-sata-phy"
+- address-cells: should be 1
+- size-cells: should be 0
+- phy-cells: from the generic PHY bindings, must be 1
+- reg: address and length of the register
+- clocks: reference to the clock entry
+
+Sub-nodes:
+Each PHY should be represented as a sub-node.
+
+Sub-nodes required properties:
+- reg: the PHY number
+
+Example:
+	sata_phy: phy@f7e900a0 {
+		compatible = "marvell,berlin2q-sata-phy";
+		reg = <0xf7e900a0 0x200>;
+		clocks = <&chip CLKID_SATA>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		#phy-cells = <1>;
+
+		sata-phy@0 {
+			reg = <0>;
+		};
+
+		sata-phy@1 {
+			reg = <1>;
+		};
+	};
-- 
1.7.9.5

