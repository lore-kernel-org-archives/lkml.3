Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaJ0SGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:06:30 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32788 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaJ0SG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:06:28 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-api@vger.kernel.org (open list:ABI/API),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/6] vfio: implement iommu driver capabilities with an enum
Date: Mon, 27 Oct 2014 19:05:50 +0100
Message-Id: <1414433155-31600-2-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414433155-31600-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1414433155-31600-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a VFIO driver's IOMMU capabilities are encoded as a series of
numerical defines. Replace this with an enum for future maintainability.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 include/uapi/linux/vfio.h | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 6612974..1e39842 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -19,19 +19,18 @@
 
 /* Kernel & User level defines for VFIO IOCTLs. */
 
-/* Extensions */
-
-#define VFIO_TYPE1_IOMMU		1
-#define VFIO_SPAPR_TCE_IOMMU		2
-#define VFIO_TYPE1v2_IOMMU		3
 /*
- * IOMMU enforces DMA cache coherence (ex. PCIe NoSnoop stripping).  This
- * capability is subject to change as groups are added or removed.
+ * Capabilities exposed by the VFIO IOMMU driver. Some capabilities are subject
+ * to change as groups are added or removed.
  */
-#define VFIO_DMA_CC_IOMMU		4
-
-/* Check if EEH is supported */
-#define VFIO_EEH			5
+enum vfio_iommu_cap {
+	VFIO_TYPE1_IOMMU	= 1,
+	VFIO_SPAPR_TCE_IOMMU	= 2,
+	VFIO_TYPE1v2_IOMMU	= 3,
+	VFIO_DMA_CC_IOMMU	= 4, /* IOMMU enforces DMA cache coherence
+					(ex. PCIe NoSnoop stripping) */
+	VFIO_EEH		= 5, /* Check if EEH is supported */
+};
 
 /*
  * The IOCTL interface is designed for extensibility by embedding the
-- 
2.1.1

