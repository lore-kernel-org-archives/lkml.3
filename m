Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbbANHZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:25:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbbANHZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3.18 012/150] swiotlb-xen: remove BUG_ON in xen_bus_to_phys
Date: Tue, 13 Jan 2015 23:21:23 -0800
Message-Id: <20150114072056.422114928@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/swiotlb-xen.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -96,8 +96,6 @@ static inline phys_addr_t xen_bus_to_phy
 	dma_addr_t dma = (dma_addr_t)pfn << PAGE_SHIFT;
 	phys_addr_t paddr = dma;
 
-	BUG_ON(paddr != dma); /* truncation has occurred, should never happen */
-
 	paddr |= baddr & ~PAGE_MASK;
 
 	return paddr;


