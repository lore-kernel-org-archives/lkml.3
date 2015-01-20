Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbbATQZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:25:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbbATQZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:25:20 -0500
Date: Tue, 20 Jan 2015 18:25:13 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kraxel@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: [PATCH 03/05] fixup! virtio_pci: macros for PCI layout offsets
Message-ID: <1421771093-1589-4-git-send-email-mst@redhat.com>
References: <1421771093-1589-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421771093-1589-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_pci_modern: fix up vendor capability macros

Gerd Hoffmann noticed that we implemented
capability layout from an old draft.
Unfortunately the code was copied to host as well,
so we didn't notice.

Luckily we caught this in time.

This fixes commit "virtio_pci: macros for PCI layout offsets"
and should be smashed with it.

Reported-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_pci.h    | 14 +++++---------
 drivers/virtio/virtio_pci_modern.c |  6 ++++--
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 0911c62..3b7e4d2 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -124,11 +124,6 @@ struct virtio_pci_cap {
 	__le32 length;		/* Length of the structure, in bytes. */
 };
 
-#define VIRTIO_PCI_CAP_BAR_SHIFT	5
-#define VIRTIO_PCI_CAP_BAR_MASK		0x7
-#define VIRTIO_PCI_CAP_TYPE_SHIFT	0
-#define VIRTIO_PCI_CAP_TYPE_MASK	0x7
-
 struct virtio_pci_notify_cap {
 	struct virtio_pci_cap cap;
 	__le32 notify_off_multiplier;	/* Multiplier for queue_notify_off. */
@@ -164,11 +159,12 @@ struct virtio_pci_common_cfg {
 #define VIRTIO_PCI_CAP_VNDR		0
 #define VIRTIO_PCI_CAP_NEXT		1
 #define VIRTIO_PCI_CAP_LEN		2
-#define VIRTIO_PCI_CAP_TYPE_AND_BAR	3
-#define VIRTIO_PCI_CAP_OFFSET		4
-#define VIRTIO_PCI_CAP_LENGTH		8
+#define VIRTIO_PCI_CAP_CFG_TYPE		3
+#define VIRTIO_PCI_CAP_BAR		4
+#define VIRTIO_PCI_CAP_OFFSET		8
+#define VIRTIO_PCI_CAP_LENGTH		12
 
-#define VIRTIO_PCI_NOTIFY_CAP_MULT	12
+#define VIRTIO_PCI_NOTIFY_CAP_MULT	16
 
 #define VIRTIO_PCI_COMMON_DFSELECT	0
 #define VIRTIO_PCI_COMMON_DF		4
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index c86594e..b2e707ad 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -474,8 +474,10 @@ static inline void check_offsets(void)
 		     offsetof(struct virtio_pci_cap, cap_next));
 	BUILD_BUG_ON(VIRTIO_PCI_CAP_LEN !=
 		     offsetof(struct virtio_pci_cap, cap_len));
-	BUILD_BUG_ON(VIRTIO_PCI_CAP_TYPE_AND_BAR !=
-		     offsetof(struct virtio_pci_cap, type_and_bar));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_CFG_TYPE !=
+		     offsetof(struct virtio_pci_cap, cfg_type));
+	BUILD_BUG_ON(VIRTIO_PCI_CAP_BAR !=
+		     offsetof(struct virtio_pci_cap, bar));
 	BUILD_BUG_ON(VIRTIO_PCI_CAP_OFFSET !=
 		     offsetof(struct virtio_pci_cap, offset));
 	BUILD_BUG_ON(VIRTIO_PCI_CAP_LENGTH !=
-- 
MST

