Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab3BLELu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:11:50 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50464 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760174Ab3BLELs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:11:48 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Cyril Roelandt <tipecaml@gmail.com>, joro@8bytes.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH 2/5] iommu: remove redundant NULL check before dma_ops_domain_free().
Date: Tue, 12 Feb 2013 05:01:50 +0100
Message-Id: <1360641713-24895-3-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360641713-24895-1-git-send-email-tipecaml@gmail.com>
References: <1360641713-24895-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_ops_domain_free on a NULL pointer is a no-op, so the NULL check in
amd_iommu_init_dma_ops() can be removed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/iommu/amd_iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d33eaaf..98f555d 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3187,8 +3187,7 @@ int __init amd_iommu_init_dma_ops(void)
 free_domains:
 
 	for_each_iommu(iommu) {
-		if (iommu->default_dom)
-			dma_ops_domain_free(iommu->default_dom);
+		dma_ops_domain_free(iommu->default_dom);
 	}
 
 	return ret;
-- 
1.7.10.4

