Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935Ab3FSAG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:06:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35525 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933796Ab3FSAEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:04:47 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Joerg Roedel <joro@8bytes.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 08/11] iommu/msm: Move mach includes to iommu directory
Date: Tue, 18 Jun 2013 17:04:38 -0700
Message-Id: <1371600281-6118-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
In-Reply-To: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two header files exist in mach-msm's include/mach directory that
are only used by the MSM iommu driver. Move these files to the
iommu driver directory and prefix them with "msm_". This allows
us to compile the MSM iommu driver on multi-platform kernels.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Joerg, please ack so this can go through the MSM tree.

 drivers/iommu/msm_iommu.c                                             | 4 ++--
 arch/arm/mach-msm/include/mach/iommu.h => drivers/iommu/msm_iommu.h   | 0
 drivers/iommu/msm_iommu_dev.c                                         | 4 ++--
 .../include/mach/iommu_hw-8xxx.h => drivers/iommu/msm_iommu_hw-8xxx.h | 0
 4 files changed, 4 insertions(+), 4 deletions(-)
 rename arch/arm/mach-msm/include/mach/iommu.h => drivers/iommu/msm_iommu.h (100%)
 rename arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h => drivers/iommu/msm_iommu_hw-8xxx.h (100%)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 8ab4f41..f5ff657 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -31,8 +31,8 @@
 #include <asm/cacheflush.h>
 #include <asm/sizes.h>
 
-#include <mach/iommu_hw-8xxx.h>
-#include <mach/iommu.h>
+#include "msm_iommu_hw-8xxx.h"
+#include "msm_iommu.h"
 
 #define MRC(reg, processor, op1, crn, crm, op2)				\
 __asm__ __volatile__ (							\
diff --git a/arch/arm/mach-msm/include/mach/iommu.h b/drivers/iommu/msm_iommu.h
similarity index 100%
rename from arch/arm/mach-msm/include/mach/iommu.h
rename to drivers/iommu/msm_iommu.h
diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index 9144a6b..2ac1033 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -27,8 +27,8 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 
-#include <mach/iommu_hw-8xxx.h>
-#include <mach/iommu.h>
+#include "msm_iommu_hw-8xxx.h"
+#include "msm_iommu.h"
 
 struct iommu_ctx_iter_data {
 	/* input */
diff --git a/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h b/drivers/iommu/msm_iommu_hw-8xxx.h
similarity index 100%
rename from arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
rename to drivers/iommu/msm_iommu_hw-8xxx.h
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

