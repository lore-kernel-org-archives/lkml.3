Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaCaNyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:54:20 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38050 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaCaNyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:54:14 -0400
From: Srikanth Thokala <sthokal@xilinx.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: lars@metafoo.de, andriy.shevchenko@linux.intel.com,
        jaswinder.singh@linaro.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH 1/2] dma: Add Xilinx Central DMA DT Binding Documentation
Date: Mon, 31 Mar 2014 19:24:03 +0530
Message-Id: <1396274044-6524-1-git-send-email-sthokal@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device-tree binding documentation of Xilinx Central DMA Engine

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
---
 .../devicetree/bindings/dma/xilinx/xilinx_cdma.txt |   54 ++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_cdma.txt

diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_cdma.txt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_cdma.txt
new file mode 100644
index 0000000..b04f76b
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_cdma.txt
@@ -0,0 +1,54 @@
+Xilinx AXI CDMA engine, it does transfers between memory-mapped source
+address and a memory-mapped destination address.
+
+Required properties:
+- compatible: Should be "xlnx,axi-cdma-1.00.a"
+- #dma-cells: Should be <1>, see "dmas" property below
+- reg: Should contain cdma registers location and length.
+- dma-channel child node: Should have only one channel
+
+Optional properties:
+- xlnx,include-sg: Tells whether configured for Scatter-mode in
+	the hardware.
+
+Required child node properties:
+- compatible: It should be "xlnx,axi-cdma-channel".
+- interrupts: Should contain per channel CDMA interrupts.
+- xlnx,data-width: Should contain the stream data width, take values
+	{32,64...1024}.
+
+Option child node properties:
+- xlnx,include-dre: Tells whether hardware is configured for Data
+	Realignment Engine.
+
+Example:
+++++++++
+
+axi_cdma_0: axicdma@7e200000 {
+	compatible = "xlnx,axi-cdma-1.00.a";
+	#dma_cells = <1>;
+	reg = < 0x7e200000 0x10000 >;
+	dma-channel@7e200000 {
+		compatible = "xlnx,axi-cdma-channel";
+		interrupts = < 0 55 4 >;
+		xlnx,datawidth = <0x40>;
+	} ;
+} ;
+
+
+* DMA client
+
+Required properties:
+- dmas: a list of <[Central DMA device phandle] [Channel ID]> pairs,
+	where Channel ID is '0' for write/tx and '1' for read/rx
+	channel.
+- dma-names: a list of DMA channel names, one per "dmas" entry
+
+Example:
+++++++++
+
+cdmatest_0: cdmatest@0 {
+	compatible ="xlnx,axi-cdma-test-1.00.a";
+	dmas = <&axi_cdma_0 0>;
+	dma-names = "cdma0";
+} ;
-- 
1.7.9.5

