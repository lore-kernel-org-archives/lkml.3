Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaFERE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:04:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38381 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaFERE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:04:26 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v6 06/20] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
Date: Thu,  5 Jun 2014 19:03:14 +0200
Message-Id: <1401987808-23596-7-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
and expose its availability via the capability VFIO_IOMMU_PROT_NOEXEC.
This way the user can control whether the XN flag will be set on the
requested mappings. The IOMMU_NOEXEC flag needs to be available for all
the IOMMUs of the container used.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 include/uapi/linux/vfio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index cb9023d..29d234c 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -29,6 +29,7 @@
  * capability is subject to change as groups are added or removed.
  */
 #define VFIO_DMA_CC_IOMMU		4
+#define VFIO_IOMMU_PROT_NOEXEC		5
 
 /*
  * The IOCTL interface is designed for extensibility by embedding the
@@ -398,6 +399,7 @@ struct vfio_iommu_type1_dma_map {
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+#define VFIO_DMA_MAP_FLAG_NOEXEC (1 << 2)	/* not executable from device */
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
-- 
1.8.3.2

