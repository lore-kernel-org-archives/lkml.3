Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbaK0MoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:44:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbaK0MbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:31:18 -0500
Date: Thu, 27 Nov 2014 14:30:55 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>, Pawel Moll <pawel.moll@arm.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v5 10/45] virtio: allow transports to get avail/used addresses
Message-ID: <1417091078-24611-11-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
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
index b311fa7..5c8aef8 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -827,4 +827,20 @@ void virtio_break_device(struct virtio_device *dev)
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

