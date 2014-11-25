Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaKYQtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:49:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaKYQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:43:27 -0500
Date: Tue, 25 Nov 2014 18:43:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 25/42] vhost: add memory access wrappers
Message-ID: <1416933600-21398-26-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416933600-21398-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.h | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 3eda654..b9032e8 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -174,6 +174,37 @@ enum {
 
 static inline int vhost_has_feature(struct vhost_virtqueue *vq, int bit)
 {
-	return vq->acked_features & (1 << bit);
+	return vq->acked_features & (1ULL << bit);
+}
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
 }
 #endif
-- 
MST

