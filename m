Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaBQUYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:24:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbaBQUYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:24:07 -0500
Subject: [PATCH 3/4] vfio: Add external user check extension interface
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 13:24:06 -0700
Message-ID: <20140217202406.22775.50151.stgit@bling.home>
In-Reply-To: <20140217201324.22775.31904.stgit@bling.home>
References: <20140217201324.22775.31904.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets us check extensions, particularly VFIO_DMA_CC_IOMMU using
the external user interface, allowing KVM to probe IOMMU coherency.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c  |    6 ++++++
 include/linux/vfio.h |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 21271d8..512f479 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1413,6 +1413,12 @@ int vfio_external_user_iommu_id(struct vfio_group *group)
 }
 EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
 
+long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
+{
+	return vfio_ioctl_check_extension(group->container, arg);
+}
+EXPORT_SYMBOL_GPL(vfio_external_check_extension);
+
 /**
  * Module/class support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 24579a0..81022a52 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -96,5 +96,7 @@ extern void vfio_unregister_iommu_driver(
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
+extern long vfio_external_check_extension(struct vfio_group *group,
+					  unsigned long arg);
 
 #endif /* VFIO_H */

