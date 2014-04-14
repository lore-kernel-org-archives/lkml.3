Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaDNK4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:56:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbaDNKzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:55:40 -0400
Date: Mon, 14 Apr 2014 12:55:38 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] driver core: dev_set_drvdata can no longer fail
Message-ID: <20140414125538.21ec0d7e@endymion.delvare>
In-Reply-To: <20140414124802.2859439e@endymion.delvare>
References: <20140414124802.2859439e@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So there is no point in checking its return value, which will soon
disappear.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/exynos-iommu.c |    7 +------
 drivers/vfio/vfio.c          |    8 +-------
 2 files changed, 2 insertions(+), 13 deletions(-)

--- linux-3.15-rc0.orig/drivers/iommu/exynos-iommu.c	2014-04-08 16:23:59.159885163 +0200
+++ linux-3.15-rc0/drivers/iommu/exynos-iommu.c	2014-04-08 16:25:47.491199974 +0200
@@ -542,12 +542,7 @@ static int exynos_sysmmu_probe(struct pl
 		goto err_alloc;
 	}
 
-	ret = dev_set_drvdata(dev, data);
-	if (ret) {
-		dev_dbg(dev, "Unabled to initialize driver data\n");
-		goto err_init;
-	}
-
+	dev_set_drvdata(dev, data);
 	data->nsfrs = pdev->num_resources / 2;
 	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
 								GFP_KERNEL);
--- linux-3.15-rc0.orig/drivers/vfio/vfio.c	2014-04-08 16:23:59.159885163 +0200
+++ linux-3.15-rc0/drivers/vfio/vfio.c	2014-04-08 16:28:14.690345108 +0200
@@ -349,7 +349,6 @@ struct vfio_device *vfio_group_create_de
 					     void *device_data)
 {
 	struct vfio_device *device;
-	int ret;
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (!device)
@@ -360,12 +359,7 @@ struct vfio_device *vfio_group_create_de
 	device->group = group;
 	device->ops = ops;
 	device->device_data = device_data;
-
-	ret = dev_set_drvdata(dev, device);
-	if (ret) {
-		kfree(device);
-		return ERR_PTR(ret);
-	}
+	dev_set_drvdata(dev, device);
 
 	/* No need to get group_lock, caller has group reference */
 	vfio_group_get(group);

-- 
Jean Delvare
SUSE L3 Support
