Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaDCLLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:11:07 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:47415 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaDCLKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:10:42 -0400
From: Harini Katakam <harinik@xilinx.com>
To: broonie@kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Harini Katakam <harinik@xilinx.com>
Subject: [PATCH v2 2/2] devicetree: Add devicetree bindings documentation for Cadence SPI
Date: Thu,  3 Apr 2014 16:40:31 +0530
Message-Id: <1396523431-14519-2-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add spi-cadence bindings documentation.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---

v2 changes:
- Separate patch for bindings.
- Add xilinx compatible string; Make compatible string first in the node.
- Use property name num-cs. Make this property optional.

---
 .../devicetree/bindings/spi/spi-cadence.txt        |   27 ++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-cadence.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-cadence.txt b/Documentation/devicetree/bindings/spi/spi-cadence.txt
new file mode 100644
index 0000000..ccb7599
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-cadence.txt
@@ -0,0 +1,27 @@
+Cadence SPI controller Device Tree Bindings
+-------------------------------------------
+
+Required properties:
+- compatible		: Should be "cdns,spi-r1p6" or "xlnx,zynq-spi-r1p6".
+- reg			: Physical base address and size of SPI registers map.
+- interrupts		: Property with a value describing the interrupt
+			  number.
+- interrupt-parent	: Must be core interrupt controller
+- clock-names		: List of input clock names - "ref_clk", "pclk"
+			  (See clock bindings for details).
+- clocks		: Clock phandles (see clock bindings for details).
+
+Optional properties:
+- num-cs		: Number of chip selects used.
+
+Example:
+
+	spi@e0007000 {
+		compatible = "xlnx,zynq-spi-r1p6";
+		clock-names = "ref_clk", "pclk";
+		clocks = <&clkc 26>, <&clkc 35>;
+		interrupt-parent = <&intc>;
+		interrupts = <0 49 4>;
+		num-cs = /bits/ 16 <4>;
+		reg = <0xe0007000 0x1000>;
+	} ;
-- 
1.7.9.5

