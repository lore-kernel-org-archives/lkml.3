Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaFMRao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:30:44 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63248 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaFMRal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:30:41 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 1/2] include/uapi/linux/virtio_blk.h: introduce feature of VIRTIO_BLK_F_MQ
Date: Sat, 14 Jun 2014 01:29:21 +0800
Message-Id: <1402680562-8328-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current virtio-blk spec only supports one virtual queue for transfering
data between VM and host, and inside VM all kinds of operations on
the virtual queue needs to hold one lock, so cause below problems:

	- no scalability
    - bad throughput

So this patch requests to introduce feature of VIRTIO_BLK_F_MQ
so that more than one virtual queues can be used to virtio-blk
device, then above problems can be solved or eased.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/uapi/linux/virtio_blk.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
index 6d8e61c..c5a2751 100644
--- a/include/uapi/linux/virtio_blk.h
+++ b/include/uapi/linux/virtio_blk.h
@@ -40,6 +40,7 @@
 #define VIRTIO_BLK_F_WCE	9	/* Writeback mode enabled after reset */
 #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
 #define VIRTIO_BLK_F_CONFIG_WCE	11	/* Writeback mode available in config */
+#define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
 
 #ifndef __KERNEL__
 /* Old (deprecated) name for VIRTIO_BLK_F_WCE. */
@@ -77,6 +78,9 @@ struct virtio_blk_config {
 
 	/* writeback mode (if VIRTIO_BLK_F_CONFIG_WCE) */
 	__u8 wce;
+
+	/* number of vqs, only available when VIRTIO_BLK_F_MQ is set */
+	__u16 num_queues;
 } __attribute__((packed));
 
 /*
-- 
1.7.9.5

