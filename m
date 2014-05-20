Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaETMjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:39:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39036 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaETMjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:39:40 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 5/6] iommu/vt-d: use inline function dma_pte_superpage instead of macros
Date: Tue, 20 May 2014 20:37:51 +0800
Message-ID: <1400589472-8544-6-git-send-email-wangyijing@huawei.com>
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

Use inline function dma_pte_superpage() instead of macro for
better readability.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d1d6636..455896c 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -891,7 +891,7 @@ static struct dma_pte *dma_pfn_level_pte(struct dmar_domain *domain,
 			break;
 		}
 
-		if (pte->val & DMA_PTE_LARGE_PAGE) {
+		if (dma_pte_superpage(pte)) {
 			*large_page = total;
 			return pte;
 		}
-- 
1.7.1


