Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaAGWru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 17:47:50 -0500
Received: from 8bytes.org ([85.214.48.195]:37060 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaAGWrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 17:47:43 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Rob Clark <robdclark@gmail.com>, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] drm/msm: Fix link error with !MSM_IOMMU
Date: Tue,  7 Jan 2014 23:47:26 +0100
Message-Id: <1389134846-1000-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan  7 23:47:40 2014
X-DSPAM-Confidence: 0.9984
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52cc840c20861967921452
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DRM driver for MSM depends on symbols from the MSM
IOMMU driver. Add this dependency to the Kconfig file.

Fixes this comile error:

  Kernel: arch/arm/boot/zImage is ready
  ERROR: "msm_iommu_get_ctx" [drivers/gpu/drm/msm/msm.ko]
  undefined!
  make[2]: *** [__modpost] Error 1

Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/gpu/drm/msm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
index f39ab75..d3de8e1 100644
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@ -4,6 +4,7 @@ config DRM_MSM
 	depends on DRM
 	depends on ARCH_MSM
 	depends on ARCH_MSM8960
+	depends on MSM_IOMMU
 	select DRM_KMS_HELPER
 	select SHMEM
 	select TMPFS
-- 
1.7.9.5


