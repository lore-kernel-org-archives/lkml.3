Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbaJ3G1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:27:14 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:53909 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbaJ3G1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:27:12 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] msm: iommu: use dev_get_platdata()
Date: Thu, 30 Oct 2014 11:55:11 +0530
Message-Id: <1414650311-24211-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/iommu/msm_iommu_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index 9574d21..b6d01f9 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -131,7 +131,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
 	struct clk *iommu_clk;
 	struct clk *iommu_pclk;
 	struct msm_iommu_drvdata *drvdata;
-	struct msm_iommu_dev *iommu_dev = pdev->dev.platform_data;
+	struct msm_iommu_dev *iommu_dev = dev_get_platdata(&pdev->dev);
 	void __iomem *regs_base;
 	int ret, irq, par;
 
@@ -263,7 +263,7 @@ static int msm_iommu_remove(struct platform_device *pdev)
 
 static int msm_iommu_ctx_probe(struct platform_device *pdev)
 {
-	struct msm_iommu_ctx_dev *c = pdev->dev.platform_data;
+	struct msm_iommu_ctx_dev *c = dev_get_platdata(&pdev->dev);
 	struct msm_iommu_drvdata *drvdata;
 	struct msm_iommu_ctx_drvdata *ctx_drvdata;
 	int i, ret;
-- 
1.7.9.5

