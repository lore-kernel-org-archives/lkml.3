Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaEVMhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:37:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45701 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038AbaEVMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:37:13 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Arnd Bergmann <arnd@arndb.de>, andriy.shevchenko@intel.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v9 1/2] Documentation: dt: Add Allwinner A31 DMA controller bindings
Date: Thu, 22 May 2014 14:34:43 +0200
Message-Id: <1400762084-31606-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400762084-31606-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1400762084-31606-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A31 DMA controller is rather simple to describe in the DT. Add
the bindings documentation.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../devicetree/bindings/dma/sun6i-dma.txt          | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt

diff --git a/Documentation/devicetree/bindings/dma/sun6i-dma.txt b/Documentation/devicetree/bindings/dma/sun6i-dma.txt
new file mode 100644
index 000000000000..5d7c86d52665
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/sun6i-dma.txt
@@ -0,0 +1,45 @@
+Allwinner A31 DMA Controller
+
+This driver follows the generic DMA bindings defined in dma.txt.
+
+Required properties:
+
+- compatible:	Must be "allwinner,sun6i-a31-dma"
+- reg:		Should contain the registers base address and length
+- interrupts:	Should contain a reference to the interrupt used by this device
+- clocks:	Should contain a reference to the parent AHB clock
+- resets:	Should contain a reference to the reset controller asserting
+	  	this device in reset
+- #dma-cells :	Should be 1, a single cell holding a line request number
+
+Example:
+	dma: dma-controller@01c02000 {
+		compatible = "allwinner,sun6i-a31-dma";
+		reg = <0x01c02000 0x1000>;
+		interrupts = <0 50 4>;
+		clocks = <&ahb1_gates 6>;
+		resets = <&ahb1_rst 6>;
+		#dma-cells = <1>;
+	};
+
+Clients:
+
+DMA clients connected to the A31 DMA controller must use the format
+described in the dma.txt file, using a two-cell specifier for each
+channel: a phandle plus one integer cells.
+The two cells in order are:
+
+1. A phandle pointing to the DMA controller.
+2. The port ID as specified in the datasheet
+
+Example:
+spi2: spi@01c6a000 {
+	compatible = "allwinner,sun6i-a31-spi";
+	reg = <0x01c6a000 0x1000>;
+	interrupts = <0 67 4>;
+	clocks = <&ahb1_gates 22>, <&spi2_clk>;
+	clock-names = "ahb", "mod";
+	dmas = <&dma 25>, <&dma 25>;
+	dma-names = "rx", "tx";
+	resets = <&ahb1_rst 22>;
+};
-- 
1.9.3

