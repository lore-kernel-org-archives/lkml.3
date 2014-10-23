Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaJWQVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:21:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbaJWQVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:21:06 -0400
Date: Thu, 23 Oct 2014 19:24:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC v4 07/17] virtio_config: endian conversion for v1.0
Message-ID: <1414081380-14623-8-git-send-email-mst@redhat.com>
References: <1414081380-14623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414081380-14623-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (ab)use virtio conversion functions for device-specific
config space accesses.

Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_config.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 952b6d7..05b9ff7 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -281,12 +281,13 @@ static inline u16 virtio_cread16(struct virtio_device *vdev,
 {
 	u16 ret;
 	vdev->config->get(vdev, offset, &ret, sizeof(ret));
-	return ret;
+	return virtio16_to_cpu(vdev, (__force __virtio16)ret);
 }
 
 static inline void virtio_cwrite16(struct virtio_device *vdev,
 				   unsigned int offset, u16 val)
 {
+	val = (__force u16)cpu_to_virtio16(vdev, val);
 	vdev->config->set(vdev, offset, &val, sizeof(val));
 }
 
@@ -295,12 +296,13 @@ static inline u32 virtio_cread32(struct virtio_device *vdev,
 {
 	u32 ret;
 	vdev->config->get(vdev, offset, &ret, sizeof(ret));
-	return ret;
+	return virtio32_to_cpu(vdev, (__force __virtio32)ret);
 }
 
 static inline void virtio_cwrite32(struct virtio_device *vdev,
 				   unsigned int offset, u32 val)
 {
+	val = (__force u32)cpu_to_virtio32(vdev, val);
 	vdev->config->set(vdev, offset, &val, sizeof(val));
 }
 
@@ -309,12 +311,13 @@ static inline u64 virtio_cread64(struct virtio_device *vdev,
 {
 	u64 ret;
 	vdev->config->get(vdev, offset, &ret, sizeof(ret));
-	return ret;
+	return virtio64_to_cpu(vdev, (__force __virtio64)ret);
 }
 
 static inline void virtio_cwrite64(struct virtio_device *vdev,
 				   unsigned int offset, u64 val)
 {
+	val = (__force u64)cpu_to_virtio64(vdev, val);
 	vdev->config->set(vdev, offset, &val, sizeof(val));
 }
 
-- 
MST

