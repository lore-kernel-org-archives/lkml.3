Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbbAPC3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:29:49 -0500
Received: from resqmta-ch2-10v.sys.comcast.net ([69.252.207.42]:54471 "EHLO
	resqmta-ch2-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbbAPC3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:29:48 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu: fix trace_map() to report original iova and original size
Date: Thu, 15 Jan 2015 19:29:43 -0700
Message-Id: <1421375383-8930-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_map() calls trace_map() with iova and size. trace_map()
should report original iova and original size as opposed to
iova and size after they get changed during mapping. size is
always zero at the end of mapping which is useless to report
and iova as it gets incremented, it is not as useful as the
original iova. Change iommu_map() to call trace_map() to
report original iova and original size.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Reported-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f7718d7..fbf8827 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1084,7 +1084,7 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	if (ret)
 		iommu_unmap(domain, orig_iova, orig_size - size);
 	else
-		trace_map(iova, paddr, size);
+		trace_map(orig_iova, paddr, orig_size);
 
 	return ret;
 }
-- 
1.9.1

