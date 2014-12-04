Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbaLDR04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:26:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbaLDR0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:26:55 -0500
Date: Thu, 4 Dec 2014 19:26:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC 1/3] virtio: add API to detect legacy devices
Message-ID: <1417713984-23771-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

transports need to be able to detect legacy-only
devices (ATM balloon only) to use legacy path
to drive them.

Add a core API to do just that.
The implementation just blacklists balloon:
not too pretty, but let's not over-engineer.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h  | 2 ++
 drivers/virtio/virtio.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 2bbf626..d666bcb 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -108,6 +108,8 @@ struct virtio_device {
 	void *priv;
 };
 
+bool virtio_device_is_legacy_only(struct virtio_device_id id);
+
 static inline struct virtio_device *dev_to_virtio(struct device *_dev)
 {
 	return container_of(_dev, struct virtio_device, dev);
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index fa6b75d..6b4c1113 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -267,6 +267,12 @@ static struct bus_type virtio_bus = {
 	.remove = virtio_dev_remove,
 };
 
+bool virtio_device_is_legacy_only(struct virtio_device_id id)
+{
+	return id.device == VIRTIO_ID_BALLOON;
+}
+EXPORT_SYMBOL_GPL(register_virtio_driver);
+
 int register_virtio_driver(struct virtio_driver *driver)
 {
 	/* Catch this early. */
-- 
MST

