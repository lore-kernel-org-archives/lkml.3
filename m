Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbbABOZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 09:25:34 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:55215 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbABOZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 09:25:33 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] block: fix checking return value of blk_mq_init_queue
Date: Fri,  2 Jan 2015 14:25:27 +0000
Message-Id: <1420208727-9563-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check IS_ERR_OR_NULL(return value) instead of just return value.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/null_blk.c   |    2 +-
 drivers/block/nvme-core.c  |    2 +-
 drivers/block/virtio_blk.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index ae9f615..f73fc5a 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -530,7 +530,7 @@ static int null_add_dev(void)
 			goto out_cleanup_queues;
 
 		nullb->q = blk_mq_init_queue(&nullb->tag_set);
-		if (!nullb->q) {
+		if (IS_ERR_OR_NULL(nullb->q)) {
 			rv = -ENOMEM;
 			goto out_cleanup_tags;
 		}
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index b1d5d87..0d2fbe6 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1370,7 +1370,7 @@ static int nvme_alloc_admin_tags(struct nvme_dev *dev)
 			return -ENOMEM;
 
 		dev->admin_q = blk_mq_init_queue(&dev->admin_tagset);
-		if (!dev->admin_q) {
+		if (IS_ERR_OR_NULL(dev->admin_q)) {
 			blk_mq_free_tag_set(&dev->admin_tagset);
 			return -ENOMEM;
 		}
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 7ef7c09..d594db0 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -638,7 +638,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_put_disk;
 
 	q = vblk->disk->queue = blk_mq_init_queue(&vblk->tag_set);
-	if (!q) {
+	if (IS_ERR_OR_NULL(q)) {
 		err = -ENOMEM;
 		goto out_free_tags;
 	}
-- 
1.7.9.5

