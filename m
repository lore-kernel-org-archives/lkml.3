Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3LLQkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:40:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:34803 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab3LLQko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:40:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,879,1378882800"; 
   d="scan'208";a="423669380"
From: Youquan Song <youquan.song@intel.com>
To: David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>, zhiyuan.zhou@intel.com
Subject: [PATCH 1/3] dmar: Fix domain id not update to newly create
Date: Fri, 13 Dec 2013 00:16:25 -0500
Message-Id: <1386911787-25375-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At domain_context_mapping_one(), if the domain is still not assign domain id,
it will assign a new domain_id for it, but the newly creating domain id is not
update to domain, so the domain will keep an unkown domain id.

It will cause the issues: like flush wrong domain in iommu->flush.flush_iotlb,
and free/release wrong domain.

Tested-by: Zhiyuan Zhou <zhiyuan.zhou@intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/iommu/intel-iommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 43b9bfe..9cd522f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1625,6 +1625,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
 		}
 	}
 
+	domain->id = id;
 	context_set_domain_id(context, id);
 
 	if (translation != CONTEXT_TT_PASS_THROUGH) {
-- 
1.7.7.4

