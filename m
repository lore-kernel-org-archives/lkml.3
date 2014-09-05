Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbaIEKxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:53:23 -0400
Received: from 8bytes.org ([81.169.241.247]:37803 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633AbaIEKxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:13 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Upinder Malhi <umalhi@cisco.com>
Subject: [PATCH 11/12] IB/usnic: Convert to use new iommu_capable() API function
Date: Fri,  5 Sep 2014 12:53:03 +0200
Message-Id: <1409914384-21191-12-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Cc: Upinder Malhi <umalhi@cisco.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/infiniband/hw/usnic/usnic_uiom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 801a1d6..417de1f 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -507,7 +507,7 @@ int usnic_uiom_attach_dev_to_pd(struct usnic_uiom_pd *pd, struct device *dev)
 	if (err)
 		goto out_free_dev;
 
-	if (!iommu_domain_has_cap(pd->domain, IOMMU_CAP_CACHE_COHERENCY)) {
+	if (!iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY)) {
 		usnic_err("IOMMU of %s does not support cache coherency\n",
 				dev_name(dev));
 		err = -EINVAL;
-- 
1.9.1

