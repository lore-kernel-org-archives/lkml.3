Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaJWNUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:20:47 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35602 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJWNUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:20:20 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] block: wrong return value
Date: Thu, 23 Oct 2014 18:50:09 +0530
Message-Id: <1414070409-4566-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while compiling integer err was showing as a set but unused variable.
elevator_init_fn can be either cfq_init_queue or deadline_init_queue
or noop_init_queue.
all three of these functions are returning -ENOMEM if they fail to
allocate the queue. 
so we should actually be returning the error code rather than
returning 0 always.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

hi,
if my understanding was wrong and if it is indeed a case of unusued variable,
   then please discard this patch.

 block/elevator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 24c28b6..7560417 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -184,7 +184,7 @@ static void elevator_release(struct kobject *kobj)
 int elevator_init(struct request_queue *q, char *name)
 {
 	struct elevator_type *e = NULL;
-	int err;
+	int err = 0;
 
 	/*
 	 * q->sysfs_lock must be held to provide mutual exclusion between
@@ -229,7 +229,7 @@ int elevator_init(struct request_queue *q, char *name)
 	}
 
 	err = e->ops.elevator_init_fn(q, e);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(elevator_init);
 
-- 
1.8.1.2

