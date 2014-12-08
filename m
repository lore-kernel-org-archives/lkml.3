Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaLHNGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:06:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbaLHNGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:22 -0500
Date: Mon, 8 Dec 2014 15:06:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dahi@linux.vnet.ibm.com, cornelia.huck@de.ibm.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 6/6] virtio: drop legacy_only driver flag
Message-ID: <1418042769-25539-7-git-send-email-mst@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418042769-25539-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

legacy_only flag is now unused, drop it from core.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h  | 2 --
 drivers/virtio/virtio.c | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index d666bcb..d09e093 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -134,7 +134,6 @@ int virtio_device_restore(struct virtio_device *dev);
  * @feature_table_size: number of entries in the feature table array.
  * @feature_table_legacy: same as feature_table but when working in legacy mode.
  * @feature_table_size_legacy: number of entries in feature table legacy array.
- * @legacy_only: driver does not support virtio 1.0.
  * @probe: the function to call when a device is found.  Returns 0 or -errno.
  * @remove: the function to call when a device is removed.
  * @config_changed: optional function to call when the device configuration
@@ -147,7 +146,6 @@ struct virtio_driver {
 	unsigned int feature_table_size;
 	const unsigned int *feature_table_legacy;
 	unsigned int feature_table_size_legacy;
-	bool legacy_only;
 	int (*probe)(struct virtio_device *dev);
 	void (*scan)(struct virtio_device *dev);
 	void (*remove)(struct virtio_device *dev);
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index e1673a5..f226658 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -198,10 +198,6 @@ static int virtio_dev_probe(struct device *_d)
 		driver_features_legacy = driver_features;
 	}
 
-	/* Detect legacy-only drivers and disable VIRTIO_F_VERSION_1. */
-	if (drv->legacy_only)
-		device_features &= ~(1ULL << VIRTIO_F_VERSION_1);
-
 	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
 		dev->features = driver_features & device_features;
 	else
-- 
MST

