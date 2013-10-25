Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3JYLF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:05:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:56380 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3JYLF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:05:57 -0400
X-IronPort-AV: E=Sophos;i="4.93,569,1378857600"; 
   d="scan'208";a="64688109"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 18/18] swiotlb-xen: static inline xen_phys_to_bus, xen_bus_to_phys, xen_virt_to_bus and range_straddles_page_boundary
Date: Fri, 25 Oct 2013 11:51:53 +0100
Message-ID: <1382698313-13161-18-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This functions are small and called frequently. Static inline them.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/swiotlb-xen.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 4d50058..100962d 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -72,17 +72,17 @@ static unsigned long xen_io_tlb_nslabs;
 
 static u64 start_dma_addr;
 
-static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
+static inline dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
 {
 	return phys_to_machine(XPADDR(paddr)).maddr;
 }
 
-static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
+static inline phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
 {
 	return machine_to_phys(XMADDR(baddr)).paddr;
 }
 
-static dma_addr_t xen_virt_to_bus(void *address)
+static inline dma_addr_t xen_virt_to_bus(void *address)
 {
 	return xen_phys_to_bus(virt_to_phys(address));
 }
@@ -105,7 +105,7 @@ static int check_pages_physically_contiguous(unsigned long pfn,
 	return 1;
 }
 
-static int range_straddles_page_boundary(phys_addr_t p, size_t size)
+static inline int range_straddles_page_boundary(phys_addr_t p, size_t size)
 {
 	unsigned long pfn = PFN_DOWN(p);
 	unsigned int offset = p & ~PAGE_MASK;
-- 
1.7.2.5

