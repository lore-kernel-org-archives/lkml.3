Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab3DKUxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:53:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935869Ab3DKUt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:29 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=iEtDvCP8UocA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=b7610mudhKoA:10 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=v3rLFGiuRE8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202558.178587533@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [ 073/171 ] ARM: DMA-mapping: add missing GFP_DMA flag for atomic buffer
 allocation
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0073-ARM-DMA-mapping-add-missing-GFP_DMA-flag-for-atomic-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 9d1400cf79afb49584b4873eb22cd5130cb341db ]

Atomic pool should always be allocated from DMA zone if such zone is
available in the system to avoid issues caused by limited dma mask of
any of the devices used for making an atomic allocation.

Reported-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Stable <stable@vger.kernel.org>	[v3.6+]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mm/dma-mapping.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 13f555d..a3658d6 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -311,6 +311,7 @@ static int __init atomic_pool_init(void)
 {
 	struct dma_pool *pool = &atomic_pool;
 	pgprot_t prot = pgprot_dmacoherent(pgprot_kernel);
+	gfp_t gfp = GFP_KERNEL | GFP_DMA;
 	unsigned long nr_pages = pool->size >> PAGE_SHIFT;
 	unsigned long *bitmap;
 	struct page *page;
@@ -329,8 +330,8 @@ static int __init atomic_pool_init(void)
 	if (IS_ENABLED(CONFIG_CMA))
 		ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page);
 	else
-		ptr = __alloc_remap_buffer(NULL, pool->size, GFP_KERNEL, prot,
-					   &page, NULL);
+		ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
+					   NULL);
 	if (ptr) {
 		int i;
 
-- 
1.7.10.4


