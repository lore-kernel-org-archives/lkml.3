Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaGJN0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:26:17 -0400
Received: from 8bytes.org ([85.214.48.195]:52020 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbaGJN0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:26:00 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Oded.Gabbay@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/9] iommu/amd: Don't call mmu_notifer_unregister in __unbind_pasid
Date: Thu, 10 Jul 2014 15:25:43 +0200
Message-Id: <1404998750-15536-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404998750-15536-1-git-send-email-joro@8bytes.org>
References: <1404998750-15536-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:25:58 2014
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be946620864868219607
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This function is called only in the mn_release() path, so
there is no need to unregister the mmu_notifer here.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <Oded.Gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 0e29f6f..1fdd22c 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -313,8 +313,6 @@ static void __unbind_pasid(struct pasid_state *pasid_state)
 	/* Make sure no more pending faults are in the queue */
 	flush_workqueue(iommu_wq);
 
-	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
-
 	put_pasid_state(pasid_state); /* Reference taken in bind() function */
 }
 
-- 
1.7.9.5


