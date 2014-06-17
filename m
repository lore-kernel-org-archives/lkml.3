Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbaFQOat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:30:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49478 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaFQOar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:30:47 -0400
Message-ID: <53A050BF.3000101@oracle.com>
Date: Tue, 17 Jun 2014 22:29:19 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: joro@8bytes.org
CC: iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/24]  drivers/iommu: check actual error on iommu_init
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

kset_create_and_add() has been fixed to return the actual error
code ptr rather than NULL, so update iommu_init() to check the
return value via IS_ERR() accordingly.

Cc: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 drivers/iommu/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e5555fc..297b5ad 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -925,7 +925,7 @@ static int __init iommu_init(void)
 	ida_init(&iommu_group_ida);
 	mutex_init(&iommu_group_mutex);
 
-	BUG_ON(!iommu_group_kset);
+	BUG_ON(IS_ERR(iommu_group_kset));
 
 	return 0;
 }
-- 
1.8.3.2
