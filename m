Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaHFEnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:43:19 -0400
Received: from s87.loopia.se ([194.9.94.112]:33557 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaHFEnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:43:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: will.deacon@arm.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 03/15] iommu/arm-smmu: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:42:01 -0700
Message-Id: <1407300121-32432-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/iommu/arm-smmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index ca18d6d..d84f983 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -623,7 +623,7 @@ static irqreturn_t arm_smmu_context_fault(int irq, void *dev)
 
 	if (fsr & FSR_IGN)
 		dev_err_ratelimited(smmu->dev,
-				    "Unexpected context fault (fsr 0x%u)\n",
+				    "Unexpected context fault (fsr 0x%x)\n",
 				    fsr);
 
 	fsynr = readl_relaxed(cb_base + ARM_SMMU_CB_FSYNR0);
-- 
2.0.0.526.g5318336

