Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345Ab3D3WVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab3D3WV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:21:28 -0400
Subject: [PATCH] vfio: Set container device mode
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 30 Apr 2013 16:21:24 -0600
Message-ID: <20130430222108.31600.19391.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor 0 is the VFIO container device (/dev/vfio/vfio).  On it's own
the container does not provide a user with any privileged access.  It
only supports API version check and extension check ioctls.  Only by
attaching a VFIO group to the container does it gain any access.  Set
the mode of the container to allow access.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index ac7423b..acb7121 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -27,6 +27,7 @@
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
@@ -1359,6 +1360,9 @@ static const struct file_operations vfio_device_fops = {
  */
 static char *vfio_devnode(struct device *dev, umode_t *mode)
 {
+	if (MINOR(dev->devt) == 0)
+		*mode = S_IRUGO | S_IWUGO;
+
 	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
 }
 

