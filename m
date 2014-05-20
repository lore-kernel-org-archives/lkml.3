Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaETMjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:39:10 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4559 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaETMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:38:52 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 4/6] iommu/vt-d: clear the redundant assignment for domain->nid
Date: Tue, 20 May 2014 20:37:50 +0800
Message-ID: <1400589472-8544-5-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
References: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alloc_domain() will initialize domain->nid to -1. So the
initialization for domain->nid in md_domain_init() is redundant,
clear it.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/intel-iommu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6b71608..d1d6636 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4134,7 +4134,6 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	domain->iommu_snooping = 0;
 	domain->iommu_superpage = 0;
 	domain->max_addr = 0;
-	domain->nid = -1;
 
 	/* always allocate the top pgd */
 	domain->pgd = (struct dma_pte *)alloc_pgtable_page(domain->nid);
-- 
1.7.1


