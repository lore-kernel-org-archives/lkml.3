Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaJMNHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:07:13 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45790 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaJMNG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:06:58 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: will.deacon@arm.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, jroedel@suse.de
Cc: alex.williamson@redhat.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM SMMU DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] iommu/arm-smmu: add IOMMU_CAP_NOEXEC to the ARM SMMU driver
Date: Mon, 13 Oct 2014 15:06:18 +0200
Message-Id: <1413205579-6124-4-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205579-6124-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205579-6124-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM SMMU supports the IOMMU_NOEXEC protection flag. Add the
corresponding IOMMU capability.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/arm-smmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 566c176..c8fc02f 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1569,6 +1569,8 @@ static bool arm_smmu_capable(enum iommu_cap cap)
 		return true;
 	case IOMMU_CAP_INTR_REMAP:
 		return true; /* MSIs are just memory writes */
+	case IOMMU_CAP_NOEXEC:
+		return true;
 	default:
 		return false;
 	}
-- 
2.1.1

