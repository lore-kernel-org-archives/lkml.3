Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaJTLpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:45:47 -0400
Received: from down.free-electrons.com ([37.187.137.238]:48929 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbaJTLpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:45:35 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yassin Jaffer <yassinjaffer@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 2/2] mtd: nand: add sunxi NFC dt bindings doc
Date: Mon, 20 Oct 2014 13:45:20 +0200
Message-Id: <1413805520-14947-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413805520-14947-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1413805520-14947-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the sunxi NAND Flash Controller dt bindings documentation.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/mtd/sunxi-nand.txt         | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/sunxi-nand.txt b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
new file mode 100644
index 0000000..0273adb
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
@@ -0,0 +1,45 @@
+Allwinner NAND Flash Controller (NFC)
+
+Required properties:
+- compatible : "allwinner,sun4i-a10-nand".
+- reg : shall contain registers location and length for data and reg.
+- interrupts : shall define the nand controller interrupt.
+- #address-cells: shall be set to 1. Encode the nand CS.
+- #size-cells : shall be set to 0.
+- clocks : shall reference nand controller clocks.
+- clock-names : nand controller internal clock names. Shall contain :
+    * "ahb" : AHB gating clock
+    * "mod" : nand controller clock
+
+Optional children nodes:
+Children nodes represent the available nand chips.
+
+Optional properties:
+- allwinner,rb : shall contain the native Ready/Busy ids.
+ or
+- rb-gpios : shall contain the gpios used as R/B pins.
+- nand-ecc-mode : one of the supported ECC modes ("hw", "hw_syndrome", "soft",
+  "soft_bch" or "none")
+
+see Documentation/devicetree/mtd/nand.txt for generic bindings.
+
+
+Examples:
+nfc: nand@01c03000 {
+	compatible = "allwinner,sun4i-a10-nand";
+	reg = <0x01c03000 0x1000>;
+	interrupts = <0 37 1>;
+	clocks = <&ahb_gates 13>, <&nand_clk>;
+	clock-names = "ahb", "mod";
+	#address-cells = <1>;
+	#size-cells = <0>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&nand_pins_a &nand_cs0_pins_a &nand_rb0_pins_a>;
+	status = "okay";
+
+	nand@0 {
+		reg = <0>;
+		allwinner,rb = <0>;
+		nand-ecc-mode = "soft_bch";
+	};
+};
-- 
1.9.1

