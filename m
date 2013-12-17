Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3LQNjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:39:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52776 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab3LQNjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:39:52 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: =?UTF-8?q?=5BPATCH=20v4=206/9=5D=20mtd=3A=20nand=3A=20davinci=3A=20extend=20description=20of=20bindings?=
Date: Tue, 17 Dec 2013 15:37:37 +0200
Message-ID: <1387287457-19873-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend bindings for davinci_nand driver to be more clear.
This is clarification only, without semantic changes.

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Taras Kondratiuk <taras@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 .../devicetree/bindings/mtd/davinci-nand.txt       |   77 ++++++++++++++------
 1 file changed, 54 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
index 3545ea7..d2a3fc0 100644
--- a/Documentation/devicetree/bindings/mtd/davinci-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
@@ -1,36 +1,67 @@
-* Texas Instruments Davinci NAND
+Device tree bindings for Texas instruments Davinci NAND controller
 
-This file provides information, what the device node for the
-davinci nand interface contain.
+This file provides information, what the device node for the davinci NAND
+interface contains.
+
+Documentation:
+Davinci DM646x - http://www.ti.com/lit/ug/sprueq7c/sprueq7c.pdf
 
 Required properties:
-- compatible: "ti,davinci-nand";
-- reg : contain 2 offset/length values:
-        - offset and length for the access window
-        - offset and length for accessing the aemif control registers
-- ti,davinci-chipselect: Indicates on the davinci_nand driver which
-                         chipselect is used for accessing the nand.
+
+- compatible:			"ti,davinci-nand"
+
+- reg:				Contains 2 offset/length values:
+				- offset and length for the access window.
+				- offset and length for accessing the AEMIF
+				control registers.
+
+- ti,davinci-chipselect:	number of chipselect. Indicates on the
+				davinci_nand driver which chipselect is used
+				for accessing the nand.
+				Can be in the range [0-3].
 
 Recommended properties :
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
+
+- ti,davinci-mask-ale:		mask for ALE. Needed for executing address
+				phase. These offset will be added to the base
+				address for the chip select space the NAND Flash
+				device is connected to.
+				If not set equal to 0x08.
+
+- ti,davinci-mask-cle:		mask for CLE. Needed for executing command
+				phase. These offset will be added to the base
+				address for the chip select space the NAND Flash
+				device is connected to.
+				If not set equal to 0x10.
+
+- ti,davinci-mask-chipsel:	mask for chipselect address. Needed to mask
+				addresses for given chipselect.
+
+- ti,davinci-ecc-mode:		operation mode of the NAND ecc mode. ECC mode
+				valid values for davinci driver:
+				- "none"
+				- "soft"
+				- "hw"
+
+- ti,davinci-ecc-bits:		used ECC bits, currently supported 1 or 4.
+
+- ti,davinci-nand-buswidth:	buswidth 8 or 16.
+
+- ti,davinci-nand-use-bbt:	use flash based bad block table support. OOB
+				identifier is saved in OOB area.
+
+Nand device bindings may contain additional sub-nodes describing partitions of
+the address space. See partition.txt for more detail. The NAND Flash timing
+values must be programmed in the chip select’s node of AEMIF
+memory-controller (see Documentation/devicetree/bindings/memory-controllers/
+davinci-aemif.txt).
 
 Example(da850 EVM ):
+
 nand_cs3@62000000 {
 	compatible = "ti,davinci-nand";
 	reg = <0x62000000 0x807ff
-		0x68000000 0x8000>;
+	       0x68000000 0x8000>;
 	ti,davinci-chipselect = <1>;
 	ti,davinci-mask-ale = <0>;
 	ti,davinci-mask-cle = <0>;
-- 
1.7.9.5

