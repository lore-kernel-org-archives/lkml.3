Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaF3NL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:11:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54471 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753076AbaF3NLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:11:21 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 5/7] Documentation: bindings: document the sub-nodes AHCI bindings
Date: Mon, 30 Jun 2014 15:09:30 +0200
Message-Id: <1404133772-11741-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404133772-11741-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1404133772-11741-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The libahci now allows to use multiple PHYs and to represent each port
as a sub-node. Add these bindings to the documentation.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 .../devicetree/bindings/ata/ahci-platform.txt      | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index c96d8dcf98fd..24d95fccfb4a 100644
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -3,6 +3,10 @@
 SATA nodes are defined to describe on-chip Serial ATA controllers.
 Each SATA controller should have its own node.
 
+It is possible, but not required, to represent each port as a sub-node.
+It allows to enable each port independently when dealing with multiple
+PHYs.
+
 Required properties:
 - compatible        : compatible string, one of:
   - "allwinner,sun4i-a10-ahci"
@@ -14,6 +18,7 @@ Required properties:
   - "snps,dwc-ahci"
   - "snps,exynos5440-ahci"
   - "snps,spear-ahci"
+  - "generic-ahci"
 - interrupts        : <interrupt mapping for SATA IRQ>
 - reg               : <registers mapping>
 
@@ -21,11 +26,23 @@ Optional properties:
 - dma-coherent      : Present if dma operations are coherent
 - clocks            : a list of phandle + clock specifier pairs
 - target-supply     : regulator for SATA target power
+- phys              : reference to the SATA PHY node
+- phy-names         : must be "sata-phy"
 
 "fsl,imx53-ahci", "fsl,imx6q-ahci" required properties:
 - clocks            : must contain the sata, sata_ref and ahb clocks
 - clock-names       : must contain "ahb" for the ahb clock
 
+Required properties when using sub-nodes:
+- #address-cells    : number of cells to encode an address
+- #size-cells       : number of cells representing the size of an address
+
+
+Sub-nodes required properties:
+- reg               : the port number
+- phys              : reference to the SATA PHY node
+
+
 Examples:
         sata@ffe08000 {
 		compatible = "snps,spear-ahci";
@@ -40,3 +57,23 @@ Examples:
 		clocks = <&pll6 0>, <&ahb_gates 25>;
 		target-supply = <&reg_ahci_5v>;
 	};
+
+With sub-nodes:
+	sata@f7e90000 {
+		compatible = "generic-ahci";
+		reg = <0xe90000 0x1000>;
+		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&chip CLKID_SATA>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		sata0: sata-port@0 {
+			reg = <0>;
+			phys = <&sata_phy 0>;
+		};
+
+		sata1: sata-port@1 {
+			reg = <1>;
+			phys = <&sata_phy 1>;
+		};
+	};
-- 
1.9.1

