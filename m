Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3FDTZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 15:25:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52411 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3FDTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 15:25:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/12] msm: iommu: Use clk_set_rate() instead of clk_set_min_rate()
Date: Tue,  4 Jun 2013 12:25:32 -0700
Message-Id: <1370373938-32417-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org>
References: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling clk_set_min_rate() is no better than just calling
clk_set_rate() because MSM clock code already takes care of
calling the min_rate ops if the clock really needs
clk_set_min_rate() called on it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/iommu/msm_iommu_dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index d344f6a..9144a6b 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -29,7 +29,6 @@
 
 #include <mach/iommu_hw-8xxx.h>
 #include <mach/iommu.h>
-#include <mach/clk.h>
 
 struct iommu_ctx_iter_data {
 	/* input */
@@ -168,7 +167,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
 
 	if (!IS_ERR(iommu_clk))	{
 		if (clk_get_rate(iommu_clk) == 0)
-			clk_set_min_rate(iommu_clk, 1);
+			clk_set_rate(iommu_clk, 1);
 
 		ret = clk_prepare_enable(iommu_clk);
 		if (ret) {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

