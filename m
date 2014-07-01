Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbaGAQUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:20:53 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53116 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbaGAQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/20] drivers/block: Use RCU_INIT_POINTER(x, NULL) in drbd/drbd_state.c
Date: Tue,  1 Jul 2014 18:16:41 +0200
Message-Id: <1404231410-29852-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Monam Agarwal <monamagarwal123@gmail.com>

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure
is carried out before storing a pointer to that structure.
And in the case of the NULL pointer, there is no structure to initialize.
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index a7772e2..4a75b7a 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1570,7 +1570,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 		old_conf = connection->net_conf;
 		connection->my_addr_len = 0;
 		connection->peer_addr_len = 0;
-		rcu_assign_pointer(connection->net_conf, NULL);
+		RCU_INIT_POINTER(connection->net_conf, NULL);
 		conn_free_crypto(connection);
 		mutex_unlock(&connection->resource->conf_update);
 
-- 
1.9.1

