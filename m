Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3LBK37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:29:59 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:61190 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3LBK34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:29:56 -0500
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH 1/1] NULL return of kmem_cache_zalloc should be handled
Date: Mon,  2 Dec 2013 18:29:41 +0800
Message-Id: <1385980181-26381-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if iopte is NULL, iopte_free should not be called.

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

