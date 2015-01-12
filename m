Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbbALSRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:17:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbbALSG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 081/216] swiotlb-xen: remove BUG_ON in xen_bus_to_phys
Date: Mon, 12 Jan 2015 18:03:18 +0000
Message-Id: <1421085933-32536-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit c884227eaae9936f8ecbde6e1387bccdab5f4e90 upstream.

On x86 truncation cannot occur because config XEN depends on X86_64 ||
(X86_32 && X86_PAE).

On ARM truncation can occur without CONFIG_ARM_LPAE, when the dma
operation involves foreign grants. However in that case the physical
address returned by xen_bus_to_phys is actually invalid (there is no mfn
to pfn tracking for foreign grants on ARM) and it is not used.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/swiotlb-xen.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index bc6fb0d24ad5..f21282da9876 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -96,8 +96,6 @@ static inline phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
 	dma_addr_t dma = (dma_addr_t)pfn << PAGE_SHIFT;
 	phys_addr_t paddr = dma;
 
-	BUG_ON(paddr != dma); /* truncation has occurred, should never happen */
-
 	paddr |= baddr & ~PAGE_MASK;
 
 	return paddr;
-- 
2.1.4

