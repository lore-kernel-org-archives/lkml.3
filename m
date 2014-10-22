Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaJVSoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:44:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbaJVSlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:41:15 -0400
Date: Wed, 22 Oct 2014 21:44:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC v3 08/16] virtio: allow transports to get avail/used
 addresses
Message-ID: <1414003404-505-9-git-send-email-mst@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414003404-505-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

For virtio-1, we can theoretically have a more complex virtqueue
layout with avail and used buffers not on a contiguous memory area
with the descriptor table. For now, it's fine for a transport driver
to stay with the old layout: It needs, however, a way to access
the locations of the avail/used rings so it can register them with
the host.

Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h       |  3 +++
 drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 149284e..d6359a5 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -75,6 +75,9 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
 
 bool virtqueue_is_broken(struct virtqueue *vq);
 
+void *virtqueue_get_avail(struct virtqueue *vq);
+void *virtqueue_get_used(struct virtqueue *vq);
+
 /**
  * virtio_device - representation of a device using virtio
  * @index: unique position on the virtio bus
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 9f5dfe3..1db44ba 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -829,4 +829,20 @@ void virtio_break_device(struct virtio_device *dev)
 }
 EXPORT_SYMBOL_GPL(virtio_break_device);
 
+void *virtqueue_get_avail(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	return vq->vring.avail;
+}
+EXPORT_SYMBOL_GPL(virtqueue_get_avail);
+
+void *virtqueue_get_used(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	return vq->vring.used;
+}
+EXPORT_SYMBOL_GPL(virtqueue_get_used);
+
 MODULE_LICENSE("GPL");
-- 
MST

