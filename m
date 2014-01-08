Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaAHO0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:26:32 -0500
Received: from 20.mo3.mail-out.ovh.net ([178.33.47.94]:38863 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755890AbaAHO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:26:25 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [RFC PATCH 6/9] mtd: nand: add sunxi NFC dt bindings doc
Date: Wed,  8 Jan 2014 15:22:01 +0100
Message-Id: <1389190924-26226-7-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6922595577740294339
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the sunxi NAND Flash Controller dt bindings documentation.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../devicetree/bindings/mtd/sunxi-nand.txt         |   71 ++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/sunxi-nand.txt b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
new file mode 100644
index 0000000..c3206fc
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
@@ -0,0 +1,71 @@
+Allwinner NAND Flash Controller (NFC)
+
+Required properties:
+- compatible : "allwinner,sun4i-nfc".
+- reg : shall contain registers location and length for data and reg.
+- interrupts : shall define the NFC interrupt.
+- #address-cells: shall be set to 1. Encode the nand CS.
+- #size-cells : shall be set to 0.
+- clocks : shall reference NFC clocks.
+- clock-names : NFC internal clock names. Shall contain :
+    * "ahb_clk" : AHB gating clock
+    * "sclk" : NFC clock
+
+Optional children nodes:
+Children nodes represent the available nand chips.
+
+Required properties:
+- reg : shall contain the CS ids (a given chip might use several CS)
+- tCLS-min : see Documentation/devicetree/mtd/nand.txt
+- tCLH-min : Documentation/devicetree/mtd/nand.txt
+- tCS-min : see Documentation/devicetree/mtd/nand.txt
+- tCH-min : see Documentation/devicetree/mtd/nand.txt
+- tWP-min : see Documentation/devicetree/mtd/nand.txt
+- tWH-min : see Documentation/devicetree/mtd/nand.txt
+- tALS-min : see Documentation/devicetree/mtd/nand.txt
+- tDS-min : see Documentation/devicetree/mtd/nand.txt
+- tDH-min : see Documentation/devicetree/mtd/nand.txt
+- tRR-min : see Documentation/devicetree/mtd/nand.txt
+- tALH-min : see Documentation/devicetree/mtd/nand.txt
+- tRP-min : see Documentation/devicetree/mtd/nand.txt
+- tREH-min : see Documentation/devicetree/mtd/nand.txt
+- tRC-min : see Documentation/devicetree/mtd/nand.txt
+- tWC-min : see Documentation/devicetree/mtd/nand.txt
+
+Optional properties:
+- allwinner,rb : shall contain the native Ready/Busy ids.
+ or
+- rb-gpios : shall contain the gpios used as R/B pins.
+
+see Documentation/devicetree/mtd/nand.txt for generic bindings.
+
+
+Examples:
+nfc: nand@01c03000 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&nand_pins_a &nand_cs0_pins_a &nand_rb0_pins_a>;
+	status = "okay";
+
+	nand@0 {
+		reg = <0>;
+		allwinner,rb = <0>;
+		nand-ecc-mode = "soft_bch";
+
+		/* nand timings */
+		tCLS-min = <6>;
+		tCLH-min = <3>;
+		tCS-min = <20>;
+		tCH-min = <5>;
+		tWP-min = <8>;
+		tWH-min = <6>;
+		tALS-min = <6>;
+		tDS-min = <6>;
+		tDH-min = <2>;
+		tRR-min = <20>;
+		tALH-min = <3>;
+		tRP-min = <8>;
+		tREH-min = <6>;
+		tRC-min = <16>;
+		tWC-min = <16>;
+	};
+};
-- 
1.7.9.5

