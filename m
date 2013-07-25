Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3GYPf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:35:26 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34873 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3GYPfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:35:18 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-samsung-soc@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] iommu/exynos: Follow kernel coding style for __sysmmu_enable return type
Date: Thu, 25 Jul 2013 17:35:00 +0200
Message-Id: <1374766502-14823-2-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374766502-14823-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1374766502-14823-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On success, the __sysmmu_enable returns 1 instead of 0, which does not
respect the convention described in Chapter 16 of the Linux kernel coding
style.

In fact, this return value is propagated all the way up to
iommu_attach_device() and iommu_attach_device() in drivers/iommu.c,
which results into inconsistent behavior of the IOMMU API with Exynos
systems, compared to other IOMMUs.

This patch replaces the return value with 0, which makes the Exynos'
IOMMU driver behavior consistent with that of other IOMMUs.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/exynos-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c7dd4b5..4ea3abb 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -504,7 +504,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 
 		dev_dbg(data->sysmmu, "Enabled\n");
 	} else {
-		ret = (pgtable == data->pgtable) ? 1 : -EBUSY;
+		ret = (pgtable == data->pgtable) ? 0 : -EBUSY;
 
 		dev_dbg(data->sysmmu, "already enabled\n");
 	}
-- 
1.8.1.2

