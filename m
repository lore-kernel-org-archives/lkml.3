Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3LLQkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:40:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:36417 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab3LLQkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:40:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,879,1378882800"; 
   d="scan'208";a="423669431"
From: Youquan Song <youquan.song@intel.com>
To: David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>, zhiyuan.zhou@intel.com
Subject: [PATCH 2/3] dmar: Move the confuse comments to proper place
Date: Fri, 13 Dec 2013 00:16:26 -0500
Message-Id: <1386911787-25375-2-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1386911787-25375-1-git-send-email-youquan.song@intel.com>
References: <1386911787-25375-1-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the "found=1" should be "there are other device owned by the domain", the
comments is put at wrong place and make the code reviewing confuse, so move it
to the correct place.

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/iommu/intel-iommu.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 9cd522f..aa821fc 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3813,10 +3813,6 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 				continue;
 		}
 
-		/* if there is no other devices under the same iommu
-		 * owned by this domain, clear this iommu in iommu_bmp
-		 * update iommu count and coherency
-		 */
 		if (iommu == device_to_iommu(info->segment, info->bus,
 					    info->devfn))
 			found = 1;
@@ -3824,6 +3820,10 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
+	/* if there is no other devices under the same iommu
+	 * owned by this domain, clear this iommu in iommu_bmp
+	 * update iommu count and coherency
+	 */
 	if (found == 0) {
 		unsigned long tmp_flags;
 		spin_lock_irqsave(&domain->iommu_lock, tmp_flags);
-- 
1.7.7.4

