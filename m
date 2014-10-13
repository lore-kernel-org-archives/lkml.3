Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaJMNJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:09:32 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42533 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaJMNJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:09:31 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/5] vfio/iommu_type1: support for platform bus devices on ARM
Date: Mon, 13 Oct 2014 15:09:04 +0200
Message-Id: <1413205748-6300-2-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to make use of the VFIO_IOMMU_TYPE1 driver with platform
devices on ARM. The driver can then be used with an Exynos SMMU, or
ARM SMMU driver.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index d8c5763..a0abe04 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -16,7 +16,7 @@ config VFIO_SPAPR_EEH
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
-	select VFIO_IOMMU_TYPE1 if X86
+	select VFIO_IOMMU_TYPE1 if X86 || ARM
 	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
 	select VFIO_SPAPR_EEH if (PPC_POWERNV || PPC_PSERIES)
 	select ANON_INODES
-- 
2.1.1

