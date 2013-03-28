Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3C1GTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:19:18 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:64546 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3C1GTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:19:17 -0400
Message-ID: <1364451550.4448.1.camel@phoenix>
Subject: [PATCH] iommu: exynos: Fix out of bound array access
From: Axel Lin <axel.lin@ingics.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, KyongHo Cho <pullip.cho@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 14:19:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of no-match in "for (i = 0; i < (pdev->num_resources / 2); i++)",
i is "pdev->num_resources / 2". Fix the boundary checking to avoid the out of
bound array access for data->sfrbases[i].

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/iommu/exynos-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 238a3ca..de04e6a 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -357,7 +357,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 			break;
 	}
 
-	if (i == pdev->num_resources) {
+	if (i == pdev->num_resources / 2) {
 		itype = SYSMMU_FAULT_UNKNOWN;
 	} else {
 		itype = (enum exynos_sysmmu_inttype)
-- 
1.7.10.4



