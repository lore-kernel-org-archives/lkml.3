Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3KTPXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:23:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab3KTPXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:23:38 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH 5/7] mtd: nand: davinci: move bindings under mtd
Date: Wed, 20 Nov 2013 17:22:23 +0200
Message-ID: <1384960945-14528-6-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384960945-14528-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1384960945-14528-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move bindings under mtd. Do this in order to make davinci-nand
driver usable by keystone architecture.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 .../devicetree/bindings/arm/davinci/nand.txt       |   46 --------------------
 .../devicetree/bindings/mtd/davinci-nand.txt       |   46 ++++++++++++++++++++
 2 files changed, 46 insertions(+), 46 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/davinci/nand.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/davinci-nand.txt

diff --git a/Documentation/devicetree/bindings/arm/davinci/nand.txt b/Documentation/devicetree/bindings/arm/davinci/nand.txt
deleted file mode 100644
index 3545ea7..0000000
--- a/Documentation/devicetree/bindings/arm/davinci/nand.txt
+++ /dev/null
@@ -1,46 +0,0 @@
-* Texas Instruments Davinci NAND
-
-This file provides information, what the device node for the
-davinci nand interface contain.
-
-Required properties:
-- compatible: "ti,davinci-nand";
-- reg : contain 2 offset/length values:
-        - offset and length for the access window
-        - offset and length for accessing the aemif control registers
-- ti,davinci-chipselect: Indicates on the davinci_nand driver which
-                         chipselect is used for accessing the nand.
-
-Recommended properties :
-- ti,davinci-mask-ale: mask for ale
-- ti,davinci-mask-cle: mask for cle
-- ti,davinci-mask-chipsel: mask for chipselect
-- ti,davinci-ecc-mode: ECC mode valid values for davinci driver:
-		- "none"
-		- "soft"
-		- "hw"
-- ti,davinci-ecc-bits: used ECC bits, currently supported 1 or 4.
-- ti,davinci-nand-buswidth: buswidth 8 or 16
-- ti,davinci-nand-use-bbt: use flash based bad block table support.
-
-nand device bindings may contain additional sub-nodes describing
-partitions of the address space. See partition.txt for more detail.
-
-Example(da850 EVM ):
-nand_cs3@62000000 {
-	compatible = "ti,davinci-nand";
-	reg = <0x62000000 0x807ff
-		0x68000000 0x8000>;
-	ti,davinci-chipselect = <1>;
-	ti,davinci-mask-ale = <0>;
-	ti,davinci-mask-cle = <0>;
-	ti,davinci-mask-chipsel = <0>;
-	ti,davinci-ecc-mode = "hw";
-	ti,davinci-ecc-bits = <4>;
-	ti,davinci-nand-use-bbt;
-
-	partition@180000 {
-		label = "ubifs";
-		reg = <0x180000 0x7e80000>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
new file mode 100644
index 0000000..3545ea7
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
@@ -0,0 +1,46 @@
+* Texas Instruments Davinci NAND
+
+This file provides information, what the device node for the
+davinci nand interface contain.
+
+Required properties:
+- compatible: "ti,davinci-nand";
+- reg : contain 2 offset/length values:
+        - offset and length for the access window
+        - offset and length for accessing the aemif control registers
+- ti,davinci-chipselect: Indicates on the davinci_nand driver which
+                         chipselect is used for accessing the nand.
+
+Recommended properties :
+- ti,davinci-mask-ale: mask for ale
+- ti,davinci-mask-cle: mask for cle
+- ti,davinci-mask-chipsel: mask for chipselect
+- ti,davinci-ecc-mode: ECC mode valid values for davinci driver:
+		- "none"
+		- "soft"
+		- "hw"
+- ti,davinci-ecc-bits: used ECC bits, currently supported 1 or 4.
+- ti,davinci-nand-buswidth: buswidth 8 or 16
+- ti,davinci-nand-use-bbt: use flash based bad block table support.
+
+nand device bindings may contain additional sub-nodes describing
+partitions of the address space. See partition.txt for more detail.
+
+Example(da850 EVM ):
+nand_cs3@62000000 {
+	compatible = "ti,davinci-nand";
+	reg = <0x62000000 0x807ff
+		0x68000000 0x8000>;
+	ti,davinci-chipselect = <1>;
+	ti,davinci-mask-ale = <0>;
+	ti,davinci-mask-cle = <0>;
+	ti,davinci-mask-chipsel = <0>;
+	ti,davinci-ecc-mode = "hw";
+	ti,davinci-ecc-bits = <4>;
+	ti,davinci-nand-use-bbt;
+
+	partition@180000 {
+		label = "ubifs";
+		reg = <0x180000 0x7e80000>;
+	};
+};
-- 
1.7.9.5

