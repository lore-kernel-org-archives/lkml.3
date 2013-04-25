Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3DYHMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:12:25 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:41852 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab3DYHMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:12:24 -0400
MIME-Version: 1.0
Date: Thu, 25 Apr 2013 15:12:23 +0800
Message-ID: <CAPgLHd_H=4CG95YQf8fdwieNPjXFbHuT_daJ_zDqF94EPzGudQ@mail.gmail.com>
Subject: [PATCH] msm: iommu: missing platform_driver_unregister() on error in msm_iommu_driver_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: ohad@wizery.com, davidb@codeaurora.org, joerg.roedel@amd.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing platform_driver_unregister() before return
from msm_iommu_driver_init() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/iommu/msm_iommu_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index 8e8fb07..6b56def 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -402,6 +402,7 @@ static int __init msm_iommu_driver_init(void)
 	ret = platform_driver_register(&msm_iommu_ctx_driver);
 	if (ret != 0) {
 		pr_err("Failed to register IOMMU context driver\n");
+		platform_driver_unregister(&msm_iommu_driver);
 		goto error;
 	}
 

