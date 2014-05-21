Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaEULWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:22:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53430 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaEULWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:22:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <pekon@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <robertcnelson@gmail.com>, <jg1.han@samsung.com>,
        <dwmw2@infradead.org>, <javier@dowhile0.org>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 15/16] mtd: nand: omap: Update DT binding documentation
Date: Wed, 21 May 2014 14:21:03 +0300
Message-ID: <1400671264-10702-16-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400671264-10702-1-git-send-email-rogerq@ti.com>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compatible id and other mandatory properties.
Remove deprecated 'elm_id' property as it is no longer used.

Update usage example.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/mtd/gpmc-nand.txt          | 86 +++++++++++-----------
 1 file changed, 42 insertions(+), 44 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
index 5e1f31b..49ef190 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@ -1,19 +1,22 @@
-Device tree bindings for GPMC connected NANDs
+Device tree bindings for Texas Instruments GPMC connected NANDs
 
-GPMC connected NAND (found on OMAP boards) are represented as child nodes of
-the GPMC controller with a name of "nand".
-
-All timing relevant properties as well as generic gpmc child properties are
-explained in a separate documents - please refer to
-Documentation/devicetree/bindings/bus/ti-gpmc.txt
+The TI GPMC NAND node is usually present as a child node of the GPMC controller
+node's Chip Select (CS) node. Documentation/devicetree/bindings/bus/ti-gpmc.txt
 
 For NAND specific properties such as ECC modes or bus width, please refer to
 Documentation/devicetree/bindings/mtd/nand.txt
 
-
 Required properties:
 
- - reg:		The CS line the peripheral is connected to
+ - compatible:		"ti,omap2-nand"
+ - reg:			Should contain 2 resource specifiers
+			- range, base offset and length of the NAND I/O space
+			The CS line the peripheral is connected to.
+			- range, base offset and length of the GPMC register
+			space.
+ - ti,nand-cs:		Chip select number used for the NAND device. Must match
+			the chip select used for the parent Chip Select node.
+ - interrupts:		Interrupt resource specifier for GPMC interrupt.
 
 Optional properties:
 
@@ -36,7 +39,6 @@ Optional properties:
 		"prefetch-dma"		Prefetch enabled sDMA mode
 		"prefetch-irq"		Prefetch enabled irq mode
 
- - elm_id:	<deprecated> use "ti,elm-id" instead
  - ti,elm-id:	Specifies phandle of the ELM devicetree node.
 		ELM is an on-chip hardware engine on TI SoC which is used for
 		locating ECC errors for BCHx algorithms. SoC devices which have
@@ -48,45 +50,41 @@ For inline partiton table parsing (optional):
  - #address-cells: should be set to 1
  - #size-cells: should be set to 1
 
-Example for an AM33xx board:
+Example for an OMAP3 board:
+
+gpmc {
+	...
+	ranges = <0 0 0x30000000 0x3FFFFFFF     /* I/O space */
+		  1 0 0x6e000000 0x02d4>;       /* register space */
+	...
 
-	gpmc: gpmc@50000000 {
-		compatible = "ti,am3352-gpmc";
-		ti,hwmods = "gpmc";
-		reg = <0x50000000 0x1000000>;
-		interrupts = <100>;
-		gpmc,num-cs = <8>;
-		gpmc,num-waitpins = <2>;
-		#address-cells = <2>;
-		#size-cells = <1>;
-		ranges = <0 0 0x08000000 0x2000>;	/* CS0: NAND */
-		elm_id = <&elm>;
+	cs0 {	/* chip select 0 */
+		...
+		reg = <0 0 0x1000000>;  /* CS0 partition, 16 MB min */
+		ranges;
+		...
 
 		nand@0,0 {
-			reg = <0 0 0>; /* CS0, offset 0 */
+			compatible = "ti,omap2-nand";
+			reg = <0 0 4            /* Nand I/O */
+			       1 0 0x2d4>;      /* GPMC registers */
+			interrupts = <20>;
+
+			ti,nand-cs = <0>;
 			nand-bus-width = <16>;
-			ti,nand-ecc-opt = "bch8";
-			ti,nand-xfer-type = "polled";
-
-			gpmc,sync-clk-ps = <0>;
-			gpmc,cs-on-ns = <0>;
-			gpmc,cs-rd-off-ns = <44>;
-			gpmc,cs-wr-off-ns = <44>;
-			gpmc,adv-on-ns = <6>;
-			gpmc,adv-rd-off-ns = <34>;
-			gpmc,adv-wr-off-ns = <44>;
-			gpmc,we-off-ns = <40>;
-			gpmc,oe-off-ns = <54>;
-			gpmc,access-ns = <64>;
-			gpmc,rd-cycle-ns = <82>;
-			gpmc,wr-cycle-ns = <82>;
-			gpmc,wr-access-ns = <40>;
-			gpmc,wr-data-mux-bus-ns = <0>;
+			ti,nand-ecc-opt = "ham1";
 
 			#address-cells = <1>;
 			#size-cells = <1>;
 
-			/* partitions go here */
-		};
-	};
-
+			partition@0 {
+				label = "X-Loader";
+				reg = <0 0x80000>;
+			};
+			partition@80000 {
+				label = "U-Boot";
+				reg = <0x80000 0x1e0000>;
+                        };
+		}
+	}
+}
-- 
1.8.3.2

