Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaBKCNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:13:46 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:41958 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaBKCNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:13:43 -0500
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: Joerg Roedel <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH] IOMMU: iommu module do not check NULL return of kmem_cache_zalloc
Date: Tue, 11 Feb 2014 10:12:53 +0800
Message-Id: <1392084773-16843-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhouyi Zhou <yizhouzhou@ict.ac.cn>

The function iopte_alloc do not check NULL return of kmem_cache_zalloc,
call iopte_free with argument 0 will panic.

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 drivers/iommu/omap-iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bcd78a7..5155714 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -551,7 +551,8 @@ static u32 *iopte_alloc(struct omap_iommu *obj, u32 *iopgd, u32 da)
 		dev_vdbg(obj->dev, "%s: a new pte:%p\n", __func__, iopte);
 	} else {
 		/* We raced, free the reduniovant table */
-		iopte_free(iopte);
+		if (iopte)
+			iopte_free(iopte);
 	}
 
 pte_ready:
-- 
1.7.10.4

