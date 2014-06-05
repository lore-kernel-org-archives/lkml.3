Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaFEREO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:04:14 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48616 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFEREM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:04:12 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Joerg Roedel <joro@8bytes.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Shuah Khan <shuah.kh@samsung.com>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM SMMU DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v6 01/20] iommu/arm-smmu: change IOMMU_EXEC to IOMMU_NOEXEC
Date: Thu,  5 Jun 2014 19:03:09 +0200
Message-Id: <1401987808-23596-2-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exposing the XN flag of the SMMU driver as IOMMU_NOEXEC instead of
IOMMU_EXEC makes it enforceable, since for IOMMUs that don't support
the XN flag pages will always be executable.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/arm-smmu.c | 2 +-
 include/linux/iommu.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 647c3c7..d5a2200 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1294,7 +1294,7 @@ static int arm_smmu_alloc_init_pte(struct arm_smmu_device *smmu, pmd_t *pmd,
 	}
 
 	/* If no access, create a faulting entry to avoid TLB fills */
-	if (prot & IOMMU_EXEC)
+	if (!(prot & IOMMU_NOEXEC))
 		pteval &= ~ARM_SMMU_PTE_XN;
 	else if (!(prot & (IOMMU_READ | IOMMU_WRITE)))
 		pteval &= ~ARM_SMMU_PTE_PAGE;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b96a5b2..fc464d2 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -27,7 +27,7 @@
 #define IOMMU_READ	(1 << 0)
 #define IOMMU_WRITE	(1 << 1)
 #define IOMMU_CACHE	(1 << 2) /* DMA cache coherency */
-#define IOMMU_EXEC	(1 << 3)
+#define IOMMU_NOEXEC	(1 << 3)
 
 struct iommu_ops;
 struct iommu_group;
-- 
1.8.3.2

