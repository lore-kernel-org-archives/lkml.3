Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaJWRbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:31:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbaJWRbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:31:03 -0400
Date: Thu, 23 Oct 2014 20:34:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, cornelia.huck@de.ibm.com
Subject: [PATCH] fixup! virtio: add legacy feature table support
Message-ID: <1414085648-22537-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following is needed on top of v4 virtio 1.0 support
that I sent.  Will squash it in for v5.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 85a164e..e9018b4 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -113,6 +113,13 @@ void virtio_check_driver_offered_feature(const struct virtio_device *vdev,
 	for (i = 0; i < drv->feature_table_size; i++)
 		if (drv->feature_table[i] == fbit)
 			return;
+
+	if (drv->feature_table_legacy) {
+		for (i = 0; i < drv->feature_table_size_legacy; i++)
+			if (drv->feature_table_legacy[i] == fbit)
+				return;
+	}
+
 	BUG();
 }
 EXPORT_SYMBOL_GPL(virtio_check_driver_offered_feature);
-- 
MST
