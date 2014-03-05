Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaCEKUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:20:37 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60808 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaCEKUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:20:32 -0500
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH v2] IOMMU: iopte free should check wether input argument is NULL
Date: Wed,  5 Mar 2014 18:20:19 +0800
Message-Id: <1394014820-1249-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

iopte free should check wether input argument is NULL because kmem_cache_free
will panic on NULL argument 

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Signed-off-by: Joerg Roedel <joro@8bytes.org>

---
 drivers/iommu/omap-iommu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bcd78a7..51211e8 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -523,7 +523,8 @@ static void flush_iopte_range(u32 *first, u32 *last)
 static void iopte_free(u32 *iopte)
 {
 	/* Note: freed iopte's must be clean ready for re-use */
-	kmem_cache_free(iopte_cachep, iopte);
+	if (iopte)
+		kmem_cache_free(iopte_cachep, iopte);
 }
 
 static u32 *iopte_alloc(struct omap_iommu *obj, u32 *iopgd, u32 da)


