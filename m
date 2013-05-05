Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3EEKGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 06:06:48 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:38653 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3EEKGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 06:06:33 -0400
Message-ID: <51862F3A.1020006@gmail.com>
Date: Sun, 05 May 2013 18:06:50 +0800
From: Libo Chen <chenlibo.3@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: davidb@codeaurora.org, ohad@wizery.com, joerg.roedel@amd.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lizefan@huawei.com, libo.chen@huawei.com
Subject: [PATCH 1/2] msm: iommu: add missing platform_device_unregister()
 in err case
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: libo.chen@huawei.com

We have registered msm_iommu_driver first, and need unregister it when
registered msm_iommu_ctx_driver fail

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/iommu/msm_iommu_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index 8e8fb07..4351a2d 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -401,6 +401,7 @@ static int __init msm_iommu_driver_init(void)

 	ret = platform_driver_register(&msm_iommu_ctx_driver);
 	if (ret != 0) {
+		platform_driver_unregister(&msm_iommu_driver);
 		pr_err("Failed to register IOMMU context driver\n");
 		goto error;
 	}
-- 
1.8.1.2
