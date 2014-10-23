Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaJWVnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:43:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:51994 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbaJWVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:42:59 -0400
Date: Fri, 24 Oct 2014 00:46:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH RFC] virtio_blk: WCE is assumed on under VIRTIO 1.0
Message-ID: <1414100763-546-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.0.0.545.gd9cabeb
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/block/virtio_blk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index adfba9f..1f8b111 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -478,7 +478,8 @@ static int virtblk_get_cache_mode(struct virtio_device *vdev)
 				   struct virtio_blk_config, wce,
 				   &writeback);
 	if (err)
-		writeback = virtio_has_feature(vdev, VIRTIO_BLK_F_WCE);
+		writeback = virtio_has_feature(vdev, VIRTIO_BLK_F_WCE) ||
+		            virtio_has_feature(vdev, VIRTIO_F_VERSION_1);
 
 	return writeback;
 }
-- 
MST
