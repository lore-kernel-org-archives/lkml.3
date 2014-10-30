Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbaJ3Gbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:31:40 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:34547 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbaJ3Gbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:31:39 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] iommu/omap: use dev_get_platdata()
Date: Thu, 30 Oct 2014 11:59:47 +0530
Message-Id: <1414650587-24289-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/iommu/omap-iommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 2ba3219..839cd8b 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -170,7 +170,7 @@ static int iommu_enable(struct omap_iommu *obj)
 {
 	int err;
 	struct platform_device *pdev = to_platform_device(obj->dev);
-	struct iommu_platform_data *pdata = pdev->dev.platform_data;
+	struct iommu_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata && pdata->deassert_reset) {
 		err = pdata->deassert_reset(pdev, pdata->reset_name);
@@ -190,7 +190,7 @@ static int iommu_enable(struct omap_iommu *obj)
 static void iommu_disable(struct omap_iommu *obj)
 {
 	struct platform_device *pdev = to_platform_device(obj->dev);
-	struct iommu_platform_data *pdata = pdev->dev.platform_data;
+	struct iommu_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	omap2_iommu_disable(obj);
 
@@ -1007,7 +1007,7 @@ static int omap_iommu_probe(struct platform_device *pdev)
 	int irq;
 	struct omap_iommu *obj;
 	struct resource *res;
-	struct iommu_platform_data *pdata = pdev->dev.platform_data;
+	struct iommu_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *of = pdev->dev.of_node;
 
 	obj = devm_kzalloc(&pdev->dev, sizeof(*obj) + MMU_REG_SIZE, GFP_KERNEL);
-- 
1.7.9.5

