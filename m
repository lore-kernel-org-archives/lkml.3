Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab3E1IIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:08:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327Ab3E1IIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:08:12 -0400
Date: Tue, 28 May 2013 11:08:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_pci: fix capability format, comments
Message-ID: <20130528080816.GA23399@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- queue size can actually be 0 which is not a power of 2
- fix capability format. PCI spec says:
	The layout of the information is vendor specific, except that the byte
	immediately following the “Next” pointer in the capability structure is
	defined to be a length field.
	This length field provides the number of bytes in the capability
	structure (including the ID and Next pointer bytes).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This patch is on top of the new layout branch, too

 include/uapi/linux/virtio_pci.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index cda688f..a5ef8cd 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -129,6 +129,7 @@
 struct virtio_pci_cap {
 	__u8 cap_vndr;	/* Generic PCI field: PCI_CAP_ID_VNDR */
 	__u8 cap_next;	/* Generic PCI field: next ptr. */
+	__u8 cap_len;	/* Generic PCI field: capability length */
 	__u8 cfg_type;	/* One of the VIRTIO_PCI_CAP_*_CFG. */
 	__u8 bar;		/* Where to find it. */
 	__le32 offset;	/* Offset within bar. */
@@ -154,7 +155,7 @@ struct virtio_pci_common_cfg {
 
 	/* About a specific virtqueue. */
 	__le16 queue_select;		/* read-write */
-	__le16 queue_size;		/* read-write, power of 2. */
+	__le16 queue_size;		/* read-write, power of 2, or 0. */
 	__le16 queue_msix_vector;	/* read-write */
 	__le16 queue_enable;		/* read-write */
 	__le16 queue_notify_off;	/* read-only */
-- 
MST
