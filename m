Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3HEUnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:43:07 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50979 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3HEUm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:58 -0400
Message-ID: <808c6bb1ffd0ebde59d3902adb4757ff04b2b599.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 12:37:24 -0400
Subject: [PATCH 10/20] tile PCI DMA: handle a NULL dev argument properly
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci-dma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index 7e98371..d16cfc1 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -36,8 +36,9 @@ static void *tile_dma_alloc_coherent(struct device *dev, size_t size,
 				     dma_addr_t *dma_handle, gfp_t gfp,
 				     struct dma_attrs *attrs)
 {
-	u64 dma_mask = dev->coherent_dma_mask ?: DMA_BIT_MASK(32);
-	int node = dev_to_node(dev);
+	u64 dma_mask = (dev && dev->coherent_dma_mask) ?
+		dev->coherent_dma_mask : DMA_BIT_MASK(32);
+	int node = dev ? dev_to_node(dev) : 0;
 	int order = get_order(size);
 	struct page *pg;
 	dma_addr_t addr;
-- 
1.8.3.1

