Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbaEMHok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:44:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45291 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759001AbaEMHog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:44:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH 2/4] dt/bindings: ti,edma: Remove redundant properties from documentation
Date: Tue, 13 May 2014 10:43:46 +0300
Message-ID: <1399967028-24757-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1399967028-24757-1-git-send-email-peter.ujfalusi@ti.com>
References: <1399967028-24757-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From CCCFG register of eDMA3 we can get all the needed information for the
driver about the IP:
Number of channels: NUM_DMACH
Number of regions: NUM_REGN
Number of slots (PaRAM sets): NUM_PAENTRY
Number of TC/EQ: NUM_EVQUE

The ti,edma-regions; ti,edma-slots and dma-channels in DT are
redundant since the very same information can be obtained from the HW.
The mentioned properties can be removed from the binding document.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 Documentation/devicetree/bindings/dma/ti-edma.txt | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
index 9fbbdb783a72..cf8d0a2d5b33 100644
--- a/Documentation/devicetree/bindings/dma/ti-edma.txt
+++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
@@ -2,11 +2,8 @@ TI EDMA
 
 Required properties:
 - compatible : "ti,edma3"
-- ti,edma-regions: Number of regions
-- ti,edma-slots: Number of slots
 - #dma-cells: Should be set to <1>
               Clients should use a single channel number per DMA request.
-- dma-channels: Specify total DMA channels per CC
 - reg: Memory map for accessing module
 - interrupt-parent: Interrupt controller the interrupt is routed through
 - interrupts: Exactly 3 interrupts need to be specified in the order:
@@ -26,9 +23,6 @@ edma: edma@49000000 {
 	compatible = "ti,edma3";
 	ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
 	#dma-cells = <1>;
-	dma-channels = <64>;
-	ti,edma-regions = <4>;
-	ti,edma-slots = <256>;
 	ti,edma-xbar-event-map = <1 12
 				  2 13>;
 };
-- 
1.9.3

