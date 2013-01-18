Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3ARUme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:42:34 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:63428 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3ARUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:42:33 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Joerg Roedel <joro@8bytes.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] iommu: omap-iommu.c: remove unnecessary null pointer check
Date: Fri, 18 Jan 2013 21:42:18 +0100
Message-Id: <1358541741-20708-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer obj is dereferenced in line 146 and 149 respectively, so it is not
necessary to check null again in line 149 and 175. And I have checked that all
the callers of these two functions guarantee the parameter obj passed is not
null.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/iommu/omap-iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index d33c980..6ac02fa 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -146,7 +146,7 @@ static int iommu_enable(struct omap_iommu *obj)
 	struct platform_device *pdev = to_platform_device(obj->dev);
 	struct iommu_platform_data *pdata = pdev->dev.platform_data;
 
-	if (!obj || !pdata)
+	if (!pdata)
 		return -EINVAL;
 
 	if (!arch_iommu)
@@ -172,7 +172,7 @@ static void iommu_disable(struct omap_iommu *obj)
 	struct platform_device *pdev = to_platform_device(obj->dev);
 	struct iommu_platform_data *pdata = pdev->dev.platform_data;
 
-	if (!obj || !pdata)
+	if (!pdata)
 		return;
 
 	arch_iommu->disable(obj);
-- 
1.7.10.4

