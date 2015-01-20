Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbbATQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:25:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbbATQZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:25:26 -0500
Date: Tue, 20 Jan 2015 18:25:19 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kraxel@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 05/05] virtio_pci_modern: drop an unused function
Message-ID: <1421771093-1589-6-git-send-email-mst@redhat.com>
References: <1421771093-1589-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421771093-1589-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release function in modern driver is unused:
it's a left-over from when each driver had
to have its own release.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci_modern.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 68ebc20..f16e462 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -489,14 +489,6 @@ static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 cfg_type,
 	return 0;
 }
 
-static void virtio_pci_release_dev(struct device *_d)
-{
-	struct virtio_device *vdev = dev_to_virtio(_d);
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-
-	kfree(vp_dev);
-}
-
 /* This is part of the ABI.  Don't screw with it. */
 static inline void check_offsets(void)
 {
-- 
MST

