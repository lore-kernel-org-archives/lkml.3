Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaGJIu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:50:56 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53322 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaGJIuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:50:50 -0400
From: Harini Katakam <harinik@xilinx.com>
To: broonie@kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        dwmw2@infradead.org, computersforpeace@gmail.com, marex@denx.de,
        artem.bityutskiy@linux.intel.com, geert+renesas@linux-m68k.org,
        s.hauer@pengutronix.de, jg1.han@samsung.com, sourav.poddar@ti.com
Cc: michals@xilinx.com, punnaia@xilinx.com, harinikatakamlinux@gmail.com,
        Harini Katakam <harinik@xilinx.com>
Subject: [RFC PATCH 2/2] devicetree: Add devicetree bindings documentation for Zynq QSPI
Date: Thu, 10 Jul 2014 14:20:07 +0530
Message-Id: <1404982207-4707-3-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bindings documentation for Zynq QSPI driver.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---
 .../devicetree/bindings/spi/spi-zynq-qspi.txt      |   28 ++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt b/Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt
new file mode 100644
index 0000000..288c551
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt
@@ -0,0 +1,28 @@
+Xilinx Zynq QSPI controller Device Tree Bindings
+-------------------------------------------------
+
+Required properties:
+- compatible		: Should be "xlnx,zynq-qspi-1.0".
+- reg			: Physical base address and size of QSPI registers map.
+- interrupts		: Property with a value describing the interrupt
+			  number.
+- interrupt-parent	: Must be core interrupt controller
+- clock-names		: List of input clock names - "ref_clk", "pclk"
+			  (See clock bindings for details).
+- clocks		: Clock phandles (see clock bindings for details).
+
+Optional properties:
+- num-cs		: Number of chip selects used.
+- xlnx,qspi-mode	: Single - 0; Dual Stacked - 1; Dual Parallel - 2.
+
+Example:
+	qspi@e000d000 {
+		compatible = "xlnx,zynq-qspi-1.0";
+		clock-names = "ref_clk", "pclk";
+		clocks = <&clkc 10>, <&clkc 43>;
+		interrupt-parent = <&intc>;
+		interrupts = <0 19 4>;
+		num-cs = <1>;
+		xlnx,qspi-mode = <0x0>;
+		reg = <0xe000d000 0x1000>;
+	} ;
-- 
1.7.9.5

