Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaETMmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:42:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39646 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaETMmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:42:42 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 1/6] iommu/vt-d: Use list_for_each_safe() to simplify code
Date: Tue, 20 May 2014 20:37:47 +0800
Message-ID: <1400589472-8544-2-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
References: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry_safe() instead of list_entry()
to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/intel-iommu.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f256ffc..e020dcf 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2101,13 +2101,11 @@ static inline void unlink_domain_info(struct device_domain_info *info)
 
 static void domain_remove_dev_info(struct dmar_domain *domain)
 {
-	struct device_domain_info *info;
+	struct device_domain_info *info, *tmp;
 	unsigned long flags, flags2;
 
 	spin_lock_irqsave(&device_domain_lock, flags);
-	while (!list_empty(&domain->devices)) {
-		info = list_entry(domain->devices.next,
-			struct device_domain_info, link);
+	list_for_each_entry_safe(info, tmp, &domain->devices, link) {
 		unlink_domain_info(info);
 		spin_unlock_irqrestore(&device_domain_lock, flags);
 
-- 
1.7.1


