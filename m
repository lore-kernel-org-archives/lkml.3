Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaLOVXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:23:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaLOVX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:23:26 -0500
Date: Mon, 15 Dec 2014 23:23:20 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: [PATCH 5/6] virtio_pci: add VIRTIO_PCI_NO_LEGACY
Message-ID: <1418678575-31755-6-git-send-email-mst@redhat.com>
References: <1418678575-31755-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418678575-31755-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add macro to disable all legacy register defines.
Helpful to make sure legacy macros don't leak
through into modern code.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_pci.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index e5ec1ca..35b552c 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -41,6 +41,8 @@
 
 #include <linux/virtio_config.h>
 
+#ifndef VIRTIO_PCI_NO_LEGACY
+
 /* A 32-bit r/o bitmask of the features supported by the host */
 #define VIRTIO_PCI_HOST_FEATURES	0
 
@@ -67,16 +69,11 @@
  * a read-and-acknowledge. */
 #define VIRTIO_PCI_ISR			19
 
-/* The bit of the ISR which indicates a device configuration change. */
-#define VIRTIO_PCI_ISR_CONFIG		0x2
-
 /* MSI-X registers: only enabled if MSI-X is enabled. */
 /* A 16-bit vector for configuration changes. */
 #define VIRTIO_MSI_CONFIG_VECTOR        20
 /* A 16-bit vector for selected queue notifications. */
 #define VIRTIO_MSI_QUEUE_VECTOR         22
-/* Vector value used to disable MSI for queue */
-#define VIRTIO_MSI_NO_VECTOR            0xffff
 
 /* The remaining space is defined by each driver as the per-driver
  * configuration space */
@@ -94,4 +91,12 @@
 /* The alignment to use between consumer and producer parts of vring.
  * x86 pagesize again. */
 #define VIRTIO_PCI_VRING_ALIGN		4096
+
+#endif /* VIRTIO_PCI_NO_LEGACY */
+
+/* The bit of the ISR which indicates a device configuration change. */
+#define VIRTIO_PCI_ISR_CONFIG		0x2
+/* Vector value used to disable MSI for queue */
+#define VIRTIO_MSI_NO_VECTOR            0xffff
+
 #endif
-- 
MST

