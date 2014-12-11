Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbaLKThk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:37:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760AbaLKThh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:37:37 -0500
Date: Thu, 11 Dec 2014 21:37:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, cornelia.huck@de.ibm.com,
        linux-api@vger.kernel.org
Subject: [PATCH RFC 1/5] virtio_pci: add VIRTIO_PCI_NO_LEGACY
Message-ID: <1418326570-9541-2-git-send-email-mst@redhat.com>
References: <1418326570-9541-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418326570-9541-1-git-send-email-mst@redhat.com>
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

