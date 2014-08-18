Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaHRR0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:26:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54378 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751793AbaHRR0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:26:34 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, "Dmitriy B." <rzk333@gmail.com>,
        Yassin Jaffer <yassinjaffer@gmail.com>, Jonas Meyer <quitte@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 2/2] mtd: nand: add sunxi NFC dt bindings doc
Date: Mon, 18 Aug 2014 19:26:28 +0200
Message-Id: <1408382788-32153-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408382788-32153-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1408382788-32153-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the sunxi NAND Flash Controller dt bindings documentation.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/mtd/sunxi-nand.txt         | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/sunxi-nand.txt b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
new file mode 100644
index 0000000..798c691
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
@@ -0,0 +1,45 @@
+Allwinner NAND Flash Controller (NFC)
+
+Required properties:
+- compatible : "allwinner,sun4i-nand".
+- reg : shall contain registers location and length for data and reg.
+- interrupts : shall define the nand controller interrupt.
+- #address-cells: shall be set to 1. Encode the nand CS.
+- #size-cells : shall be set to 0.
+- clocks : shall reference nand controller clocks.
+- clock-names : nand controller internal clock names. Shall contain :
+    * "ahb_clk" : AHB gating clock
+    * "sclk" : nand controller clock
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
+	compatible = "allwinner,sun4i-nand";
+	reg = <0x01c03000 0x1000>;
+	interrupts = <0 37 1>;
+	clocks = <&ahb_gates 13>, <&nand_clk>;
+	clock-names = "ahb_clk", "sclk";
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

