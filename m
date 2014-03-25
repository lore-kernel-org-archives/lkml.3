Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaCYSCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:02:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaCYRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 10/81] ARM: dma-mapping: fix GFP_ATOMIC macro usage
Date: Tue, 25 Mar 2014 10:15:23 -0700
Message-Id: <1395767794-5012-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 10c8562f932d89c030083e15f9279971ed637136 upstream.

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
atomic allocation, the code must test __GFP_WAIT flag presence. This patch
fixes the issue introduced in v3.6-rc5

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mm/dma-mapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 5397da0..eb1e6ad 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1275,7 +1275,7 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
 	*handle = DMA_ERROR_CODE;
 	size = PAGE_ALIGN(size);
 
-	if (gfp & GFP_ATOMIC)
+	if (!(gfp & __GFP_WAIT))
 		return __iommu_alloc_atomic(dev, size, handle);
 
 	pages = __iommu_alloc_buffer(dev, size, gfp, attrs);
-- 
1.8.3.2

