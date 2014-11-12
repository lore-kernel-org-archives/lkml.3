Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaKLVif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:38:35 -0500
Received: from mail-pa0-f74.google.com ([209.85.220.74]:51713 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaKLVh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:37:58 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: [PATCH 1/2] of: Add binding document for IMG SPFI controller
Date: Wed, 12 Nov 2014 13:37:53 -0800
Message-Id: <1415828274-24727-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1415828274-24727-1-git-send-email-abrestic@chromium.org>
References: <1415828274-24727-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Synchronous Peripheral Flash Interface (SPFI) controller found
on IMG SoCs supports single, dual, and (optionally) quad mode SPI
transfers.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 Documentation/devicetree/bindings/spi/spi-img.txt | 37 +++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-img.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-img.txt b/Documentation/devicetree/bindings/spi/spi-img.txt
new file mode 100644
index 0000000..c7dd50f
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-img.txt
@@ -0,0 +1,37 @@
+IMG Synchronous Peripheral Flash Interface (SPFI) controller
+
+Required properties:
+- compatible: Must be "img,spfi".
+- reg: Must contain the base address and length of the SPFI registers.
+- interrupts: Must contain the SPFI interrupt.
+- clocks: Must contain an entry for each entry in clock-names.
+  See ../clock/clock-bindings.txt for details.
+- clock-names: Must include the following entries:
+  - spfi: SPI operating clock
+  - sys: SPI system interface clock
+- dmas: Must contain an entry for each entry in dma-names.
+  See ../dma/dma.txt for details.
+- dma-names: Must include the following entries:
+  - rx
+  - tx
+- #address-cells: Must be 1.
+- #size-cells: Must be 0.
+
+Optional properties:
+- img,supports-quad-mode: Should be set if the interface supports quad mode
+  SPI transfers.
+
+Example:
+
+spi@18100f00 {
+	compatible = "img,spfi";
+	reg = <0x18100f00 0x100>;
+	interrupts = <GIC_SHARED 22 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&spi_clk>, <&system_clk>;
+	clock-names = "spfi", "sys";
+	dmas = <&mdc 9 0xffffffff 0>, <&mdc 10 0xffffffff 0>;
+	dma-names = "rx", "tx";
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+};
-- 
2.1.0.rc2.206.gedb03e5

