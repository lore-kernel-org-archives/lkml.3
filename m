Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaLAQEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:04:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbaLAQD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:03:58 -0500
Date: Mon, 1 Dec 2014 18:03:39 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Hildenbrand <dahi@linux.vnet.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v8 10/50] virtio_config: endian conversion for v1.0
Message-ID: <1417449619-24896-11-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (ab)use virtio conversion functions for device-specific
config space accesses.

Based on original patches by Cornelia and Rusty.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.com>
---
 include/linux/virtio_config.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 02f0acb..1fa5faa 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -318,12 +318,13 @@ static inline u16 virtio_cread16(struct virtio_device *vdev,
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
 
@@ -332,12 +333,13 @@ static inline u32 virtio_cread32(struct virtio_device *vdev,
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
 
@@ -346,12 +348,13 @@ static inline u64 virtio_cread64(struct virtio_device *vdev,
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

