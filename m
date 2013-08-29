Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3H2WVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:21:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39026 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752381Ab3H2WVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:21:44 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)
Date: Thu, 29 Aug 2013 15:21:42 -0700
Message-Id: <11ab0469151bbb77f45c06e73ca61112179fd727.1377814810.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the helper function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 block/cfq-iosched.c      | 2 +-
 block/deadline-iosched.c | 2 +-
 block/elevator.c         | 2 +-
 block/genhd.c            | 3 +--
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 42a52d5..7cee98a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4356,7 +4356,7 @@ static int cfq_init_queue(struct request_queue *q, struct elevator_type *e)
 	if (!eq)
 		return -ENOMEM;
 
-	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
+	cfqd = kzalloc_node(sizeof(*cfqd), GFP_KERNEL, q->node);
 	if (!cfqd) {
 		kobject_put(&eq->kobj);
 		return -ENOMEM;
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 20614a3..9ef6640 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -346,7 +346,7 @@ static int deadline_init_queue(struct request_queue *q, struct elevator_type *e)
 	if (!eq)
 		return -ENOMEM;
 
-	dd = kmalloc_node(sizeof(*dd), GFP_KERNEL | __GFP_ZERO, q->node);
+	dd = kzalloc_node(sizeof(*dd), GFP_KERNEL, q->node);
 	if (!dd) {
 		kobject_put(&eq->kobj);
 		return -ENOMEM;
diff --git a/block/elevator.c b/block/elevator.c
index 668394d..2bcbd8c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -155,7 +155,7 @@ struct elevator_queue *elevator_alloc(struct request_queue *q,
 {
 	struct elevator_queue *eq;
 
-	eq = kmalloc_node(sizeof(*eq), GFP_KERNEL | __GFP_ZERO, q->node);
+	eq = kzalloc_node(sizeof(*eq), GFP_KERNEL, q->node);
 	if (unlikely(!eq))
 		goto err;
 
diff --git a/block/genhd.c b/block/genhd.c
index 43c971f..c5c47e0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1253,8 +1253,7 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 {
 	struct gendisk *disk;
 
-	disk = kmalloc_node(sizeof(struct gendisk),
-				GFP_KERNEL | __GFP_ZERO, node_id);
+	disk = kzalloc_node(sizeof(struct gendisk), GFP_KERNEL, node_id);
 	if (disk) {
 		if (!init_part_stats(&disk->part0)) {
 			kfree(disk);
-- 
1.8.1.2.459.gbcd45b4.dirty

