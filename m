Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3A3JfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:35:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab3A3JfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:35:20 -0500
From: Hannes Reinecke <hare@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH] block: Check for valid bd_disk in bdev_get_queue()
Date: Wed, 30 Jan 2013 10:35:14 +0100
Message-Id: <1359538514-46908-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdev_get_queue() needs to check for a valid bd_disk pointer,
otherwise it'll dereference a NULL pointer.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94bc83..7e28aaa 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -794,7 +794,7 @@ extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
-	return bdev->bd_disk->queue;
+	return bdev->bd_disk ? bdev->bd_disk->queue : NULL;
 }
 
 /*
