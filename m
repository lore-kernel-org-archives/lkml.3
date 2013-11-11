Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3KKQ7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:59:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45767 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab3KKQ7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:59:41 -0500
From: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: [PATCH 05/12] mtd: nand: davinci: extend description of bindings
Thread-Topic: [PATCH 05/12] mtd: nand: davinci: extend description of
 bindings
Thread-Index: AQHO3vrUmYET3apGXkizoofXzPT/jZogP6ZW
Date: Mon, 11 Nov 2013 16:58:54 +0000
Message-ID: <4F5844B3A985794BA902E12C070812375F8D14@DNCE04.ent.ti.com>
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-6-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384187188-5776-6-git-send-email-ivan.khoronzhuk@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend bindings for davinci_nand driver to be more clear.

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
+- compatible:                  "ti,davinci-nand"
+
+- reg:                         Contains 2 offset/length values:
+                               - offset and length for the access window.
+                               - offset and length for accessing the AEMIF
+                               control registers.
+
+- ti,davinci-chipselect:       number of chipselect. Indicates on the
+                               davinci_nand driver which chipselect is used
+                               for accessing the nand.
+                               Can be in the range [0-3].

 Recommended properties :
-- ti,davinci-mask-ale: mask for ale
-- ti,davinci-mask-cle: mask for cle
-- ti,davinci-mask-chipsel: mask for chipselect
-- ti,davinci-ecc-mode: ECC mode valid values for davinci driver:
-               - "none"
-               - "soft"
-               - "hw"
-- ti,davinci-ecc-bits: used ECC bits, currently supported 1 or 4.
-- ti,davinci-nand-buswidth: buswidth 8 or 16
-- ti,davinci-nand-use-bbt: use flash based bad block table support.
-
-nand device bindings may contain additional sub-nodes describing
-partitions of the address space. See partition.txt for more detail.
+
+- ti,davinci-mask-ale:         mask for ALE. Needed for executing address
+                               phase. These offset will be added to the base
+                               address for the chip select space the NAND Flash
+                               device is connected to.
+                               If not set equal to 0x08.
+
+- ti,davinci-mask-cle:         mask for CLE. Needed for executing command
+                               phase. These offset will be added to the base
+                               address for the chip select space the NAND Flash
+                               device is connected to.
+                               If not set equal to 0x10.
+
+- ti,davinci-mask-chipsel:     mask for chipselect address. Needed to mask
+                               addresses for given chipselect.
+
+- ti,davinci-ecc-mode:         operation mode of the NAND ecc mode. ECC mode
+                               valid values for davinci driver:
+                               - "none"
+                               - "soft"
+                               - "hw"
+
+- ti,davinci-ecc-bits:         used ECC bits, currently supported 1 or 4.
+
+- ti,davinci-nand-buswidth:    buswidth 8 or 16.
+
+- ti,davinci-nand-use-bbt:     use flash based bad block table support. OOB
+                               identifier is saved in OOB area.
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
-               0x68000000 0x8000>;
+              0x68000000 0x8000>;
        ti,davinci-chipselect = <1>;
        ti,davinci-mask-ale = <0>;
        ti,davinci-mask-cle = <0>;
--
1.7.9.5

