Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3LWV7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:59:05 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60684 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab3LWV67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:59 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 19/27] drbd: struct after_conn_state_chg_work: Use drbd_work instead of drbd_device_work
Date: Mon, 23 Dec 2013 22:50:48 +0100
Message-Id: <1387835456-29695-20-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_state.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index c9a0dba..720b803 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1533,7 +1533,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 }
 
 struct after_conn_state_chg_work {
-	struct drbd_device_work dw;
+	struct drbd_work w;
 	enum drbd_conns oc;
 	union drbd_state ns_min;
 	union drbd_state ns_max; /* new, max state, over all devices */
@@ -1544,7 +1544,7 @@ struct after_conn_state_chg_work {
 static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_conn_state_chg_work *acscw =
-		container_of(w, struct after_conn_state_chg_work, dw.w);
+		container_of(w, struct after_conn_state_chg_work, w);
 	struct drbd_connection *connection = acscw->connection;
 	enum drbd_conns oc = acscw->oc;
 	union drbd_state ns_max = acscw->ns_max;
@@ -1846,10 +1846,10 @@ _conn_request_state(struct drbd_connection *connection, union drbd_state mask, u
 		acscw->ns_min = ns_min;
 		acscw->ns_max = ns_max;
 		acscw->flags = flags;
-		acscw->dw.w.cb = w_after_conn_state_ch;
+		acscw->w.cb = w_after_conn_state_ch;
 		kref_get(&connection->kref);
 		acscw->connection = connection;
-		drbd_queue_work(&connection->sender_work, &acscw->dw.w);
+		drbd_queue_work(&connection->sender_work, &acscw->w);
 	} else {
 		drbd_err(connection, "Could not kmalloc an acscw\n");
 	}
-- 
1.7.9.5

