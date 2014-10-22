Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaJVPsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:48:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbaJVPro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:47:44 -0400
Date: Wed, 22 Oct 2014 18:51:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: [PATCH RFC v2 16/16] virtio_blk: fix types for in memory structures
Message-ID: <1413992894-22976-17-git-send-email-mst@redhat.com>
References: <1413992894-22976-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413992894-22976-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_blk.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
index 9ad67b2..247c8ba 100644
--- a/include/uapi/linux/virtio_blk.h
+++ b/include/uapi/linux/virtio_blk.h
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
+#include <linux/virtio_types.h>
 
 /* Feature bits */
 #define VIRTIO_BLK_F_BARRIER	0	/* Does host support barriers? */
@@ -114,18 +115,18 @@ struct virtio_blk_config {
 /* This is the first element of the read scatter-gather list. */
 struct virtio_blk_outhdr {
 	/* VIRTIO_BLK_T* */
-	__u32 type;
+	__virtio32 type;
 	/* io priority. */
-	__u32 ioprio;
+	__virtio32 ioprio;
 	/* Sector (ie. 512 byte offset) */
-	__u64 sector;
+	__virtio64 sector;
 };
 
 struct virtio_scsi_inhdr {
-	__u32 errors;
-	__u32 data_len;
-	__u32 sense_len;
-	__u32 residual;
+	__virtio32 errors;
+	__virtio32 data_len;
+	__virtio32 sense_len;
+	__virtio32 residual;
 };
 
 /* And this is the final byte of the write scatter-gather list. */
-- 
MST

