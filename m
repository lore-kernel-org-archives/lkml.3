Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbbAUPIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:08:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbbAUPFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:05:23 -0500
Date: Wed, 21 Jan 2015 17:05:14 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Gerd Hoffmann <kraxel@redhat.com>, linux-api@vger.kernel.org
Subject: [PATCH post-squash 2/9] virtio-pci: define layout for virtio 1.0
Message-ID: <1421852670-23742-3-git-send-email-mst@redhat.com>
References: <1421852670-23742-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421852670-23742-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Based on patches by Michael S. Tsirkin <mst@redhat.com>, but I found it
hard to follow so changed to use structures which are more
self-documenting.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/uapi/linux/virtio_pci.h | 63 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 509d630..a2b2e13 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -99,4 +99,67 @@
 /* Vector value used to disable MSI for queue */
 #define VIRTIO_MSI_NO_VECTOR            0xffff
 
+#ifndef VIRTIO_PCI_NO_MODERN
+
+/* IDs for different capabilities.  Must all exist. */
+
+/* Common configuration */
+#define VIRTIO_PCI_CAP_COMMON_CFG	1
+/* Notifications */
+#define VIRTIO_PCI_CAP_NOTIFY_CFG	2
+/* ISR access */
+#define VIRTIO_PCI_CAP_ISR_CFG		3
+/* Device specific confiuration */
+#define VIRTIO_PCI_CAP_DEVICE_CFG	4
+
+/* This is the PCI capability header: */
+struct virtio_pci_cap {
+	__u8 cap_vndr;		/* Generic PCI field: PCI_CAP_ID_VNDR */
+	__u8 cap_next;		/* Generic PCI field: next ptr. */
+	__u8 cap_len;		/* Generic PCI field: capability length */
+	__u8 cfg_type;		/* Identifies the structure. */
+	__u8 bar;		/* Where to find it. */
+	__u8 padding[3];	/* Pad to full dword. */
+	__le32 offset;		/* Offset within bar. */
+	__le32 length;		/* Length of the structure, in bytes. */
+};
+
+#define VIRTIO_PCI_CAP_BAR_SHIFT	5
+#define VIRTIO_PCI_CAP_BAR_MASK		0x7
+#define VIRTIO_PCI_CAP_TYPE_SHIFT	0
+#define VIRTIO_PCI_CAP_TYPE_MASK	0x7
+
+struct virtio_pci_notify_cap {
+	struct virtio_pci_cap cap;
+	__le32 notify_off_multiplier;	/* Multiplier for queue_notify_off. */
+};
+
+/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
+struct virtio_pci_common_cfg {
+	/* About the whole device. */
+	__le32 device_feature_select;	/* read-write */
+	__le32 device_feature;		/* read-only */
+	__le32 guest_feature_select;	/* read-write */
+	__le32 guest_feature;		/* read-write */
+	__le16 msix_config;		/* read-write */
+	__le16 num_queues;		/* read-only */
+	__u8 device_status;		/* read-write */
+	__u8 config_generation;		/* read-only */
+
+	/* About a specific virtqueue. */
+	__le16 queue_select;		/* read-write */
+	__le16 queue_size;		/* read-write, power of 2. */
+	__le16 queue_msix_vector;	/* read-write */
+	__le16 queue_enable;		/* read-write */
+	__le16 queue_notify_off;	/* read-only */
+	__le32 queue_desc_lo;		/* read-write */
+	__le32 queue_desc_hi;		/* read-write */
+	__le32 queue_avail_lo;		/* read-write */
+	__le32 queue_avail_hi;		/* read-write */
+	__le32 queue_used_lo;		/* read-write */
+	__le32 queue_used_hi;		/* read-write */
+};
+
+#endif /* VIRTIO_PCI_NO_MODERN */
+
 #endif
-- 
MST

