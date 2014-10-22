Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaJVSlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:41:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbaJVSlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:41:02 -0400
Date: Wed, 22 Oct 2014 21:44:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC v3 06/16] virtio: make endian-ness depend on virtio 1.0
Message-ID: <1414003404-505-7-git-send-email-mst@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414003404-505-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio 1.0 is LE, virtio without 1.0 is native endian.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_config.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 7d46280..be0f6dd 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -157,11 +157,11 @@ int virtqueue_set_affinity(struct virtqueue *vq, int cpu)
 #define DEFINE_VIRTIO_XX_TO_CPU(bits) \
 static inline u##bits virtio##bits##_to_cpu(struct virtio_device *vdev, __virtio##bits val) \
 { \
-	return __virtio##bits##_to_cpu(false, val); \
+	return __virtio##bits##_to_cpu(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val); \
 } \
 static inline __virtio##bits cpu_to_virtio##bits(struct virtio_device *vdev, u##bits val) \
 { \
-	return __cpu_to_virtio##bits(false, val); \
+	return __cpu_to_virtio##bits(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val); \
 }
 
 DEFINE_VIRTIO_XX_TO_CPU(16)
-- 
MST

