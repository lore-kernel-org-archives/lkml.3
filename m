Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaEPHjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:39:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18226 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaEPHjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:39:22 -0400
From: Vaughan Cao <vaughan.cao@oracle.com>
To: joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        vaughan.cao@oracle.com
Subject: [PATCH] remove duplicate checking code
Date: Fri, 16 May 2014 15:39:40 +0800
Message-Id: <1400225980-12797-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.9.0
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amd_iommu_rlookup_table[devid] != NULL is already guaranteed by check_device
called before, it's fine to attach device at this point.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/iommu/amd_iommu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c949520..252851a 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3514,12 +3514,6 @@ int __init amd_iommu_init_passthrough(void)
 		dev_data = get_dev_data(&dev->dev);
 		dev_data->passthrough = true;
 
-		devid = get_device_id(&dev->dev);
-
-		iommu = amd_iommu_rlookup_table[devid];
-		if (!iommu)
-			continue;
-
 		attach_device(&dev->dev, pt_domain);
 	}
 
-- 
1.9.0

