Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaDSOeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:34:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38757 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaDSOeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:34:15 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 7/7] ARM: mm: use phys_addr_t in __dma_page_[cpu_to_dev/dev_to_cpu]
Date: Sat, 19 Apr 2014 10:32:52 -0400
Message-ID: <1397917972-6293-8-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 32 bit ARM architecture with LPAE extension physical addresses
cannot fit into unsigned long variable.

So fix it by using phys_addr_t instead of unsigned long.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mm/dma-mapping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index f62aa06..5260f43 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -885,7 +885,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
 static void __dma_page_cpu_to_dev(struct page *page, unsigned long off,
 	size_t size, enum dma_data_direction dir)
 {
-	unsigned long paddr;
+	phys_addr_t paddr;
 
 	dma_cache_maint_page(page, off, size, dir, dmac_map_area);
 
@@ -901,7 +901,7 @@ static void __dma_page_cpu_to_dev(struct page *page, unsigned long off,
 static void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
 	size_t size, enum dma_data_direction dir)
 {
-	unsigned long paddr = page_to_phys(page) + off;
+	phys_addr_t paddr = page_to_phys(page) + off;
 
 	/* FIXME: non-speculating: not required */
 	/* don't bother invalidating if DMA to device */
-- 
1.7.9.5

