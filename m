Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965839Ab3FTVLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:11:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57156 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085Ab3FTVHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:07:55 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel A Fernandes <joelagnel@ti.com>
Subject: [PATCH v12 01/11] dmaengine: edma: Add TI EDMA device tree binding
Date: Thu, 20 Jun 2013 16:06:37 -0500
Message-ID: <1371762407-24544-2-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mdp@ti.com>

The binding definition is based on the generic DMA controller
binding.

Joel:
* Droped reserved and queue DT entries from Documentation
for now from the original patch series (v10)
* Included properties in Documentation and clarified DMA properties (V11)
* Made ti,hwmod option
* Clarified DMA entries

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matt Porter <mporter@ti.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 Documentation/devicetree/bindings/dma/ti-edma.txt |   34 +++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt

diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
new file mode 100644
index 0000000..9fbbdb7
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
@@ -0,0 +1,34 @@
+TI EDMA
+
+Required properties:
+- compatible : "ti,edma3"
+- ti,edma-regions: Number of regions
+- ti,edma-slots: Number of slots
+- #dma-cells: Should be set to <1>
+              Clients should use a single channel number per DMA request.
+- dma-channels: Specify total DMA channels per CC
+- reg: Memory map for accessing module
+- interrupt-parent: Interrupt controller the interrupt is routed through
+- interrupts: Exactly 3 interrupts need to be specified in the order:
+              1. Transfer completion interrupt.
+              2. Memory protection interrupt.
+              3. Error interrupt.
+Optional properties:
+- ti,hwmods: Name of the hwmods associated to the EDMA
+- ti,edma-xbar-event-map: Crossbar event to channel map
+
+Example:
+
+edma: edma@49000000 {
+	reg = <0x49000000 0x10000>;
+	interrupt-parent = <&intc>;
+	interrupts = <12 13 14>;
+	compatible = "ti,edma3";
+	ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
+	#dma-cells = <1>;
+	dma-channels = <64>;
+	ti,edma-regions = <4>;
+	ti,edma-slots = <256>;
+	ti,edma-xbar-event-map = <1 12
+				  2 13>;
+};
-- 
1.7.9.5

