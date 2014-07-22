Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbaGVST3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:19:29 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:60975 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaGVST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:19:28 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: drbd-dev@lists.linbit.com
Cc: drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] drbd: Remove fix me statements
Date: Tue, 22 Jul 2014 14:19:21 -0400
Message-Id: <1406053161-5048-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes no longer needed fix me statements as the spinlocks
are needed to protect against other users of the list accessing
 it when items on it are being moved off it.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/block/drbd/drbd_worker.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index d8f57b6..8793a32 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1847,12 +1847,12 @@ static void wait_for_work(struct drbd_connection *connection, struct list_head *
 		int send_barrier;
 		prepare_to_wait(&connection->sender_work.q_wait, &wait, TASK_INTERRUPTIBLE);
 		spin_lock_irq(&connection->resource->req_lock);
-		spin_lock(&connection->sender_work.q_lock);	/* FIXME get rid of this one? */
+		spin_lock(&connection->sender_work.q_lock);
 		/* dequeue single item only,
 		 * we still use drbd_queue_work_front() in some places */
 		if (!list_empty(&connection->sender_work.q))
 			list_move(connection->sender_work.q.next, work_list);
-		spin_unlock(&connection->sender_work.q_lock);	/* FIXME get rid of this one? */
+		spin_unlock(&connection->sender_work.q_lock);
 		if (!list_empty(work_list) || signal_pending(current)) {
 			spin_unlock_irq(&connection->resource->req_lock);
 			break;
-- 
1.9.1

