Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3LWWDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:03:36 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60679 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3LWV64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:56 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/27] drbd: Rename drbdd_init() -> drbd_receiver()
Date: Mon, 23 Dec 2013 22:50:37 +0100
Message-Id: <1387835456-29695-9-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c     |    4 ++--
 drivers/block/drbd/drbd_nl.c       |    2 +-
 drivers/block/drbd/drbd_receiver.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 718c3bd..a2003cd 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -58,7 +58,7 @@
 #include "drbd_vli.h"
 
 static DEFINE_MUTEX(drbd_main_mutex);
-int drbdd_init(struct drbd_thread *);
+int drbd_receiver(struct drbd_thread *);
 int drbd_worker(struct drbd_thread *);
 int drbd_asender(struct drbd_thread *);
 
@@ -2616,7 +2616,7 @@ struct drbd_connection *conn_create(const char *name, struct res_opts *res_opts)
 	mutex_init(&connection->data.mutex);
 	mutex_init(&connection->meta.mutex);
 
-	drbd_thread_init(connection, &connection->receiver, drbdd_init, "receiver");
+	drbd_thread_init(connection, &connection->receiver, drbd_receiver, "receiver");
 	drbd_thread_init(connection, &connection->worker, drbd_worker, "worker");
 	drbd_thread_init(connection, &connection->asender, drbd_asender, "asender");
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a84f1e2..f7d62ff 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2332,7 +2332,7 @@ static enum drbd_state_rv conn_try_disconnect(struct drbd_connection *connection
 		/* Race breaker.  This additional state change request may be
 		 * necessary, if this was a forced disconnect during a receiver
 		 * restart.  We may have "killed" the receiver thread just
-		 * after drbdd_init() returned.  Typically, we should be
+		 * after drbd_receiver() returned.  Typically, we should be
 		 * C_STANDALONE already, now, and this becomes a no-op.
 		 */
 		rv2 = conn_request_state(connection, NS(conn, C_STANDALONE),
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 217ed11..9349113 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4843,7 +4843,7 @@ static int drbd_do_auth(struct drbd_connection *connection)
 }
 #endif
 
-int drbdd_init(struct drbd_thread *thi)
+int drbd_receiver(struct drbd_thread *thi)
 {
 	struct drbd_connection *connection = thi->connection;
 	int h;
-- 
1.7.9.5

