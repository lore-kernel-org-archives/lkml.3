Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3EEKGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 06:06:50 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:40270 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3EEKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 06:06:43 -0400
Message-ID: <51862F45.30206@gmail.com>
Date: Sun, 05 May 2013 18:07:01 +0800
From: Libo Chen <chenlibo.3@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: davidb@codeaurora.org, ohad@wizery.com, joerg.roedel@amd.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lizefan@huawei.com, libo.chen@huawei.com
Subject: [PATCH 2/2] msm: iommu: no need kfree before kzalloc successful
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: libo.chen@huawei.com

We don`t need to kfree drvdata before kzalloc successful

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/iommu/msm_iommu_dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index 4351a2d..c6c6de1 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -293,20 +293,20 @@ static int msm_iommu_ctx_probe(struct
platform_device *pdev)
 	int i, ret;
 	if (!c || !pdev->dev.parent) {
 		ret = -EINVAL;
-		goto fail;
+		goto out;
 	}

 	drvdata = dev_get_drvdata(pdev->dev.parent);

 	if (!drvdata) {
 		ret = -ENODEV;
-		goto fail;
+		goto out;
 	}

 	ctx_drvdata = kzalloc(sizeof(*ctx_drvdata), GFP_KERNEL);
 	if (!ctx_drvdata) {
 		ret = -ENOMEM;
-		goto fail;
+		goto out;
 	}
 	ctx_drvdata->num = c->num;
 	ctx_drvdata->pdev = pdev;
@@ -359,6 +359,7 @@ static int msm_iommu_ctx_probe(struct
platform_device *pdev)
 	return 0;
 fail:
 	kfree(ctx_drvdata);
+out:
 	return ret;
 }

-- 
1.8.1.2
