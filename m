Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3KHAhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:37:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46526 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab3KHAht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:37:49 -0500
From: Joel Fernandes <joelf@ti.com>
To: <devicetree@vger.kernel.org>
CC: <santosh.shilimkar@ti.com>, <linux-omap@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] doc: devicetree: Add bindings documentation for omap-des driver
Date: Thu, 7 Nov 2013 18:37:09 -0600
Message-ID: <1383871035-16608-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the generic OMAP DES crypto module describing the device
tree bindings.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 .../devicetree/bindings/crypto/omap-des.txt        | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt

diff --git a/Documentation/devicetree/bindings/crypto/omap-des.txt b/Documentation/devicetree/bindings/crypto/omap-des.txt
new file mode 100644
index 0000000..0637647
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/omap-des.txt
@@ -0,0 +1,28 @@
+OMAP SoC DES crypto Module
+
+Required properties:
+
+- compatible : Should be "ti,omap4-des"
+- ti,hwmods: Name of the hwmod associated with the DES module
+- reg : Offset and length of the register set for the module
+- interrupts : the interrupt-specifier for the DES module
+- clocks : phandle to the functional clock node of the DES module
+- clock-names : Name of the functional clock
+
+Optional properties:
+- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
+	Documentation/devicetree/bindings/dma/dma.txt
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

