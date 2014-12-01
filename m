Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaLAQFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:05:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbaLAQFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:05:43 -0500
Date: Mon, 1 Dec 2014 18:05:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v8 30/50] vhost: add memory access wrappers
Message-ID: <1417449619-24896-31-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add guest memory access wrappers to handle virtio endianness
conversions.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/vhost/vhost.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 55a95c9..a0a6c98 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -176,4 +176,35 @@ static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
 {
 	return vq->acked_features & (1ULL << bit);
 }
+
+/* Memory accessors */
+static inline u16 vhost16_to_cpu(struct vhost_virtqueue *vq, __virtio16 val)
+{
+	return __virtio16_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+}
+
+static inline __virtio16 cpu_to_vhost16(struct vhost_virtqueue *vq, u16 val)
+{
+	return __cpu_to_virtio16(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+}
+
+static inline u32 vhost32_to_cpu(struct vhost_virtqueue *vq, __virtio32 val)
+{
+	return __virtio32_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+}
+
+static inline __virtio32 cpu_to_vhost32(struct vhost_virtqueue *vq, u32 val)
+{
+	return __cpu_to_virtio32(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+}
+
+static inline u64 vhost64_to_cpu(struct vhost_virtqueue *vq, __virtio64 val)
+{
+	return __virtio64_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+}
+
+static inline __virtio64 cpu_to_vhost64(struct vhost_virtqueue *vq, u64 val)
+{
+	return __cpu_to_virtio64(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+}
 #endif
-- 
MST

