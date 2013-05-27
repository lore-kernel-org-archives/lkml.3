Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3E0P7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab3E0P73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:59:29 -0400
Date: Mon, 27 May 2013 18:59:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH rusty/virtio-pci-new-layout] virtio: new layout minor header
 fixups
Message-ID: <20130527155943.GA18246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix issues observed with the new layout code, seen
when implementing device in qemu:
	- use of uXX in uapi header
	- incorrect readonly tag on one field
	- unconditional warning breaks builds with -Werr

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This patch is on top of rusty/virtio-pci-new-layout.

 include/uapi/linux/virtio_pci.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 3e61d55..cda688f 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -86,8 +86,10 @@
 #define VIRTIO_PCI_LEGACY_VRING_ALIGN		4096
 
 #ifndef VIRTIO_PCI_NO_LEGACY
+#ifndef VIRTIO_PCI_LEGACY_COMPAT_NAMES
 /* Don't break compile of old userspace code.  These will go away. */
 #warning "Please support virtio_pci non-legacy mode!"
+#endif
 #define VIRTIO_PCI_HOST_FEATURES VIRTIO_PCI_LEGACY_HOST_FEATURES
 #define VIRTIO_PCI_GUEST_FEATURES VIRTIO_PCI_LEGACY_GUEST_FEATURES
 #define VIRTIO_PCI_QUEUE_PFN VIRTIO_PCI_LEGACY_QUEUE_PFN
@@ -125,10 +127,10 @@
 
 /* This is the PCI capability header: */
 struct virtio_pci_cap {
-	u8 cap_vndr;	/* Generic PCI field: PCI_CAP_ID_VNDR */
-	u8 cap_next;	/* Generic PCI field: next ptr. */
-	u8 cfg_type;	/* One of the VIRTIO_PCI_CAP_*_CFG. */
-	u8 bar;		/* Where to find it. */
+	__u8 cap_vndr;	/* Generic PCI field: PCI_CAP_ID_VNDR */
+	__u8 cap_next;	/* Generic PCI field: next ptr. */
+	__u8 cfg_type;	/* One of the VIRTIO_PCI_CAP_*_CFG. */
+	__u8 bar;		/* Where to find it. */
 	__le32 offset;	/* Offset within bar. */
 	__le32 length;	/* Length. */
 };
@@ -144,7 +146,7 @@ struct virtio_pci_common_cfg {
 	__le32 device_feature_select;	/* read-write */
 	__le32 device_feature;		/* read-only */
 	__le32 guest_feature_select;	/* read-write */
-	__le32 guest_feature;		/* read-only */
+	__le32 guest_feature;		/* read-write */
 	__le16 msix_config;		/* read-write */
 	__le16 num_queues;		/* read-only */
 	__u8 device_status;		/* read-write */
-- 
MST
