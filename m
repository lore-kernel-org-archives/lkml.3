Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbaBKUWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:22:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48352 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaBKUWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:22:02 -0500
From: Kumar Gala <galak@codeaurora.org>
To: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>
Cc: Kumar Gala <galak@codeaurora.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] drm/msm: drop ARCH_MSM Kconfig depend
Date: Tue, 11 Feb 2014 14:21:59 -0600
Message-Id: <1392150119-21132-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARCH_MSM depend is redundant with ARCH_MSM8960, so we can remove it.
Additionally, we are splitting Qualcomm MSM support into legacy (ARCH_MSM)
and multiplatform (ARCH_QCOM).  The MSM8960 with be ARCH_QCOM going forward
so dropping ARCH_MSM will work properly for the new ARCH_QCOM multiplatform
build.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
David/Rob,

If you can ack this I'll send it via linux-qcom/arm-soc tree's

thanks

- k
 drivers/gpu/drm/msm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
index c69d1e0..b698497 100644
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@ -3,7 +3,7 @@ config DRM_MSM
 	tristate "MSM DRM"
 	depends on DRM
 	depends on MSM_IOMMU
-	depends on (ARCH_MSM && ARCH_MSM8960) || (ARM && COMPILE_TEST)
+	depends on ARCH_MSM8960 || (ARM && COMPILE_TEST)
 	select DRM_KMS_HELPER
 	select SHMEM
 	select TMPFS
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

