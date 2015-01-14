Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbbANIGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:06:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbbANHd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:33:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3.14 09/77] swiotlb-xen: pass dev_addr to xen_dma_unmap_page and xen_dma_sync_single_for_cpu
Date: Tue, 13 Jan 2015 23:22:49 -0800
Message-Id: <20150114072224.681598705@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit d6883e6f32e07ef2cc974753ba00927de099e6d7 upstream.

xen_dma_unmap_page and xen_dma_sync_single_for_cpu take a dma_addr_t
handle as argument, not a physical address.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/swiotlb-xen.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -447,7 +447,7 @@ static void xen_unmap_single(struct devi
 
 	BUG_ON(dir == DMA_NONE);
 
-	xen_dma_unmap_page(hwdev, paddr, size, dir, attrs);
+	xen_dma_unmap_page(hwdev, dev_addr, size, dir, attrs);
 
 	/* NOTE: We use dev_addr here, not paddr! */
 	if (is_xen_swiotlb_buffer(dev_addr)) {
@@ -495,14 +495,14 @@ xen_swiotlb_sync_single(struct device *h
 	BUG_ON(dir == DMA_NONE);
 
 	if (target == SYNC_FOR_CPU)
-		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
+		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
 
 	/* NOTE: We use dev_addr here, not paddr! */
 	if (is_xen_swiotlb_buffer(dev_addr))
 		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
 
 	if (target == SYNC_FOR_DEVICE)
-		xen_dma_sync_single_for_cpu(hwdev, paddr, size, dir);
+		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
 
 	if (dir != DMA_FROM_DEVICE)
 		return;


