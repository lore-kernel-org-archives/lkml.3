Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbbAUPAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:00:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbbAUPAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:00:20 -0500
Date: Wed, 21 Jan 2015 17:00:13 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Gerd Hoffmann <kraxel@redhat.com>, linux-api@vger.kernel.org
Subject: [PATCH pre-squash 03/14] fixup! virtio-pci: define layout for virtio
 1.0
Message-ID: <1421852375-22604-4-git-send-email-mst@redhat.com>
References: <1421852375-22604-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421852375-22604-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio-pci: fix up virtio 1.0 vendor capability

Gerd Hoffmann noticed that we implemented
capability layout from an old draft.
Unfortunately the code was copied to host as well,
so we didn't notice.

Luckily we caught this in time.

This fixes commit "virtio-pci: define layout for virtio 1.0"
and should be smashed with it.

Reported-by: Gerd Hoffmann <kraxel@redhat.com>
Tested-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_pci.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 4e05423..a2b2e13 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -117,10 +117,11 @@ struct virtio_pci_cap {
 	__u8 cap_vndr;		/* Generic PCI field: PCI_CAP_ID_VNDR */
 	__u8 cap_next;		/* Generic PCI field: next ptr. */
 	__u8 cap_len;		/* Generic PCI field: capability length */
-	__u8 type_and_bar;	/* Upper 3 bits: bar.
-				 * Lower 3 is VIRTIO_PCI_CAP_*_CFG. */
+	__u8 cfg_type;		/* Identifies the structure. */
+	__u8 bar;		/* Where to find it. */
+	__u8 padding[3];	/* Pad to full dword. */
 	__le32 offset;		/* Offset within bar. */
-	__le32 length;		/* Length. */
+	__le32 length;		/* Length of the structure, in bytes. */
 };
 
 #define VIRTIO_PCI_CAP_BAR_SHIFT	5
-- 
MST

