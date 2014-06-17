Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbaFQOdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:33:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56264 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071AbaFQOdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:33:05 -0400
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 2/2] drm/msm: activate iommu support
Date: Tue, 17 Jun 2014 10:32:38 -0400
Message-Id: <1403015558-13210-3-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1403015558-13210-1-git-send-email-sviau@codeaurora.org>
References: <[PATCH] drm/msm: update and activate iommu support>
 <1403015558-13210-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes activates the iommu support for MDP5, through the
platform config structure.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
index 47b3eb0..ee30f1e 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
@@ -358,5 +358,11 @@ static struct mdp5_platform_config *mdp5_get_config(struct platform_device *dev)
 #ifdef CONFIG_OF
 	/* TODO */
 #endif
+	config.iommu = iommu_domain_alloc(&platform_bus_type, 0);
+	/* TODO hard-coded in downstream mdss, but should it be? */
+	config.max_clk = 200000000;
+	/* TODO get from DT: */
+	config.smp_blk_cnt = 22;
+
 	return &config;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

