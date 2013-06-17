Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3FQFxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:53:09 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:25726 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3FQFxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:53:07 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: David Woodhouse <dwmw2@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] x86/iommu: remove useless code
Date: Mon, 17 Jun 2013 13:51:46 +0800
Message-Id: <1371448306-6884-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Zhen-Hua" <zhen-hual@hp.com>

In intel-iommu.c, the function dma_pte_addr does not change the
value of its parameter (pte). So it is useless if it nobody catches
its return value.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel-iommu.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index b4f0e28..d9d378b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -809,7 +809,6 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				/* Someone else set it while we were thinking; use theirs. */
 				free_pgtable_page(tmp_page);
 			} else {
-				dma_pte_addr(pte);
 				domain_flush_cache(domain, pte, sizeof(*pte));
 			}
 		}
-- 
1.7.10.4

