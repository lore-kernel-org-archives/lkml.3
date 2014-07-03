Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaGCIn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:43:59 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45947 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbaGCIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 18/23] drbd: debugfs: add per connection oldest requests
Date: Thu,  3 Jul 2014 10:43:10 +0200
Message-Id: <1404376995-4877-19-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Information of former /sys/block/drbdX/drbd/oldest_requests
is already with higher detail in these files:
 debugfs/drbd/resource/$name/in_flight_summary,
 debugfs/drbd/resource/$name/volumes/$vnr/oldest_requests

This patch adds
 debugfs/drbd/resource/$name/connections/peer/oldest_requests

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index a4d0666..db70d6c 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -670,6 +670,13 @@ void drbd_debugfs_connection_add(struct drbd_connection *connection)
 	if (IS_ERR_OR_NULL(dentry))
 		goto fail;
 	connection->debugfs_conn_callback_history = dentry;
+
+	dentry = debugfs_create_file("oldest_requests", S_IRUSR|S_IRGRP,
+			connection->debugfs_conn, connection,
+			&connection_oldest_requests_fops);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	connection->debugfs_conn_oldest_requests = dentry;
 	return;
 
 fail:
-- 
1.9.1

