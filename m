Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3KCBlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 21:41:53 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52990 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3KCBlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 21:41:52 -0400
Date: Sun, 3 Nov 2013 09:41:10 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark.einon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: et131x: improve code readability
Message-ID: <6a641c2cf4a9700004755cc2830514399f1de74e.1383442264.git.gamerh2o@gmail.com>
Mail-Followup-To: ZHAO Gang <gamerh2o@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Einon <mark.einon@gmail.com>, linux-kernel@vger.kernel.org
References: <038fa53ab9e9336e1732f9f841c296bfcde87b0a.1383442264.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <038fa53ab9e9336e1732f9f841c296bfcde87b0a.1383442264.git.gamerh2o@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 drivers/staging/et131x/et131x.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index ca3332e..8c2a4a5 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1822,6 +1822,9 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		u32 __iomem *base_hi;
 		u32 __iomem *base_lo;
 
+		struct fbr_lookup *fbr;
+		fbr = rx_local->fbr[id];
+
 		if (id == 0) {
 			num_des = &rx_dma->fbr0_num_des;
 			full_offset = &rx_dma->fbr0_full_offset;
@@ -1837,12 +1840,10 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		}
 
 		/* Now's the best time to initialize FBR contents */
-		fbr_entry =
-		    (struct fbr_desc *) rx_local->fbr[id]->ring_virtaddr;
-		for (entry = 0;
-		     entry < rx_local->fbr[id]->num_entries; entry++) {
-			fbr_entry->addr_hi = rx_local->fbr[id]->bus_high[entry];
-			fbr_entry->addr_lo = rx_local->fbr[id]->bus_low[entry];
+		fbr_entry = (struct fbr_desc *)fbr->ring_virtaddr;
+		for (entry = 0; entry < fbr->num_entries; entry++) {
+			fbr_entry->addr_hi = fbr->bus_high[entry];
+			fbr_entry->addr_lo = fbr->bus_low[entry];
 			fbr_entry->word2 = entry;
 			fbr_entry++;
 		}
@@ -1850,19 +1851,16 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		/* Set the address and parameters of Free buffer ring 1 and 0
 		 * into the 1310's registers
 		 */
-		writel(upper_32_bits(rx_local->fbr[id]->ring_physaddr),
-		       base_hi);
-		writel(lower_32_bits(rx_local->fbr[id]->ring_physaddr),
-		       base_lo);
-		writel(rx_local->fbr[id]->num_entries - 1, num_des);
+		writel(upper_32_bits(fbr->ring_physaddr), base_hi);
+		writel(lower_32_bits(fbr->ring_physaddr), base_lo);
+		writel(fbr->num_entries - 1, num_des);
 		writel(ET_DMA10_WRAP, full_offset);
 
 		/* This variable tracks the free buffer ring 1 full position,
 		 * so it has to match the above.
 		 */
-		rx_local->fbr[id]->local_full = ET_DMA10_WRAP;
-		writel(((rx_local->fbr[id]->num_entries *
-					LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+		fbr->local_full = ET_DMA10_WRAP;
+		writel((fbr->num_entries * LO_MARK_PERCENT_FOR_RX / 100) - 1,
 		       min_des);
 	}
 
-- 
1.8.3.1

