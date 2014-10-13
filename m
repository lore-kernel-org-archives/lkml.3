Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaJMNJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:09:35 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42959 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaJMNJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:09:33 -0400
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
Subject: [PATCH 2/5] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
Date: Mon, 13 Oct 2014 15:09:05 +0200
Message-Id: <1413205748-6300-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
and expose its availability via the capability VFIO_DMA_NOEXEC_IOMMU.
This way the user can control whether the XN flag will be set on the
requested mappings. The IOMMU_NOEXEC flag needs to be available for all
the IOMMUs of the container used.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 include/uapi/linux/vfio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 6612974..111b5e8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -29,6 +29,7 @@
  * capability is subject to change as groups are added or removed.
  */
 #define VFIO_DMA_CC_IOMMU		4
+#define VFIO_DMA_NOEXEC_IOMMU		5
 
 /* Check if EEH is supported */
 #define VFIO_EEH			5
@@ -401,6 +402,7 @@ struct vfio_iommu_type1_dma_map {
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+#define VFIO_DMA_MAP_FLAG_NOEXEC (1 << 2)	/* not executable from device */
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
-- 
2.1.1

