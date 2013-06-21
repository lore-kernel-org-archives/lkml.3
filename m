Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423065Ab3FUCwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 22:52:08 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39789 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422900Ab3FUCwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 22:52:06 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH] vfio: fix documentation
Date: Fri, 21 Jun 2013 12:51:54 +1000
Message-Id: <1371783114-22516-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 Documentation/vfio.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/vfio.txt b/Documentation/vfio.txt
index c55533c..d7993dc 100644
--- a/Documentation/vfio.txt
+++ b/Documentation/vfio.txt
@@ -172,12 +172,12 @@ group and can access them as follows:
 	struct vfio_device_info device_info = { .argsz = sizeof(device_info) };
 
 	/* Create a new container */
-	container = open("/dev/vfio/vfio, O_RDWR);
+	container = open("/dev/vfio/vfio", O_RDWR);
 
 	if (ioctl(container, VFIO_GET_API_VERSION) != VFIO_API_VERSION)
 		/* Unknown API version */
 
-	if (!ioctl(container, VFIO_CHECK_EXTENSION, VFIO_X86_IOMMU))
+	if (!ioctl(container, VFIO_CHECK_EXTENSION, VFIO_TYPE1_IOMMU))
 		/* Doesn't support the IOMMU driver we want. */
 
 	/* Open the group */
@@ -193,7 +193,7 @@ group and can access them as follows:
 	ioctl(group, VFIO_GROUP_SET_CONTAINER, &container);
 
 	/* Enable the IOMMU model we want */
-	ioctl(container, VFIO_SET_IOMMU, VFIO_X86_IOMMU)
+	ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_IOMMU)
 
 	/* Get addition IOMMU info */
 	ioctl(container, VFIO_IOMMU_GET_INFO, &iommu_info);
-- 
1.7.10.4

