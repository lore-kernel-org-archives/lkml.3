Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3CZWoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab3CZWoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [ 97/98] ARM: DMA-mapping: add missing GFP_DMA flag for atomic buffer allocation
Date: Tue, 26 Mar 2013 15:43:26 -0700
Message-Id: <20130326224252.514068917@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 9d1400cf79afb49584b4873eb22cd5130cb341db upstream.

Atomic pool should always be allocated from DMA zone if such zone is
available in the system to avoid issues caused by limited dma mask of
any of the devices used for making an atomic allocation.

Reported-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/dma-mapping.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -330,6 +330,7 @@ static int __init atomic_pool_init(void)
 {
 	struct dma_pool *pool = &atomic_pool;
 	pgprot_t prot = pgprot_dmacoherent(pgprot_kernel);
+	gfp_t gfp = GFP_KERNEL | GFP_DMA;
 	unsigned long nr_pages = pool->size >> PAGE_SHIFT;
 	unsigned long *bitmap;
 	struct page *page;
@@ -348,8 +349,8 @@ static int __init atomic_pool_init(void)
 	if (IS_ENABLED(CONFIG_CMA))
 		ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page);
 	else
-		ptr = __alloc_remap_buffer(NULL, pool->size, GFP_KERNEL, prot,
-					   &page, NULL);
+		ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
+					   NULL);
 	if (ptr) {
 		int i;
 


