Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3KKTuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:50:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33255 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab3KKTt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:49:56 -0500
From: Joel Fernandes <joelf@ti.com>
To: <devicetree@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Rutland <mark.rutland@arm.com>, Joel Fernandes <joelf@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] doc: devicetree: Add bindings documentation for omap-des driver
Date: Mon, 11 Nov 2013 13:49:41 -0600
Message-ID: <1384199386-14504-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the generic OMAP DES crypto modul describing the device
tree bindings.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
v2 changes: Update documentation for clocks, clock-names and dma-names.

 .../devicetree/bindings/crypto/omap-des.txt        | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt

diff --git a/Documentation/devicetree/bindings/crypto/omap-des.txt b/Documentation/devicetree/bindings/crypto/omap-des.txt
new file mode 100644
index 0000000..e8c63bf
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/omap-des.txt
@@ -0,0 +1,30 @@
+OMAP SoC DES crypto Module
+
+Required properties:
+
+- compatible : Should contain "ti,omap4-des"
+- ti,hwmods: Name of the hwmod associated with the DES module
+- reg : Offset and length of the register set for the module
+- interrupts : the interrupt-specifier for the DES module
+- clocks : A phandle to the functional clock node of the DES module
+           corresponding to each entry in clock-names
+- clock-names : Name of the functional clock, should be "fck"
+
+Optional properties:
+- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
+	Documentation/devicetree/bindings/dma/dma.txt
+	Each entry corresponds to an entry in dma-names
+- dma-names: DMA request names should include "tx" and "rx" if present
+
+Example:
+	/* DRA7xx SoC */
+	des: des@480a5000 {
+		compatible = "ti,omap4-des";
+		ti,hwmods = "des";
+		reg = <0x480a5000 0xa0>;
+		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
+		dmas = <&sdma 117>, <&sdma 116>;
+		dma-names = "tx", "rx";
+		clocks = <&l3_iclk_div>;
+		clock-names = "fck";
+	};
-- 
1.8.1.2

