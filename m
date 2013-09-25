Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3IYOtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:49:52 -0400
Received: from 8bytes.org ([85.214.48.195]:47668 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab3IYOtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:49:49 -0400
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3/3] Fix compile error in drivers/gpu/drm/msm/msm_drv.c with IOMMU disabled
Date: Wed, 25 Sep 2013 16:49:42 +0200
Message-Id: <1380120582-9068-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380120582-9068-1-git-send-email-joro@8bytes.org>
References: <1380120582-9068-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Sep 25 16:49:47 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5242f80b20861052149761
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function msm_iommu_get_ctx() is needed buy the MSM-GPU
driver with and wiithout IOMMU compiled in. Make the
function available when no IOMMU driver is there.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/msm_iommu.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/msm_iommu.h b/drivers/iommu/msm_iommu.h
index 5c7c955..da53558 100644
--- a/drivers/iommu/msm_iommu.h
+++ b/drivers/iommu/msm_iommu.h
@@ -108,7 +108,14 @@ struct msm_iommu_ctx_drvdata {
  * Useful for testing and drivers that do not yet fully have IOMMU stuff in
  * their platform devices.
  */
+#ifdef CONFIG_MSM_IOMMU
 struct device *msm_iommu_get_ctx(const char *ctx_name);
+#else
+static inline struct device *msm_iommu_get_ctx(const char *ctx_name)
+{
+	return NULL;
+}
+#endif
 
 /*
  * Interrupt handler for the IOMMU context fault interrupt. Hooking the
-- 
1.7.9.5


