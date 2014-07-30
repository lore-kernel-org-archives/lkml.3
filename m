Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaG3OF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:05:56 -0400
Received: from 8bytes.org ([81.169.241.247]:59117 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbaG3OEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:04:52 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/4] iommu/amd: Remove change_pte mmu_notifier call-back
Date: Wed, 30 Jul 2014 16:04:38 +0200
Message-Id: <1406729080-2486-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406729080-2486-1-git-send-email-joro@8bytes.org>
References: <1406729080-2486-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

All calls to this call-back are wrapped with
mmu_notifer_invalidate_range_start()/end(), making this
notifier pretty useless, so remove it.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 2b7de88..524fd67 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -406,14 +406,6 @@ static int mn_clear_flush_young(struct mmu_notifier *mn,
 	return 0;
 }
 
-static void mn_change_pte(struct mmu_notifier *mn,
-			  struct mm_struct *mm,
-			  unsigned long address,
-			  pte_t pte)
-{
-	__mn_flush_page(mn, address);
-}
-
 static void mn_invalidate_page(struct mmu_notifier *mn,
 			       struct mm_struct *mm,
 			       unsigned long address)
@@ -484,7 +476,6 @@ static void mn_release(struct mmu_notifier *mn, struct mm_struct *mm)
 static struct mmu_notifier_ops iommu_mn = {
 	.release		= mn_release,
 	.clear_flush_young      = mn_clear_flush_young,
-	.change_pte             = mn_change_pte,
 	.invalidate_page        = mn_invalidate_page,
 	.invalidate_range_start = mn_invalidate_range_start,
 	.invalidate_range_end   = mn_invalidate_range_end,
-- 
1.9.1

