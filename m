Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaCVUda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:33:30 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64372 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaCVUd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:33:27 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/block: Use RCU_INIT_POINTER(x, NULL) in drbd/drbd_state.c
Date: Sun, 23 Mar 2014 02:02:29 +0530
Message-Id: <1395520349-3033-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/block/drbd/drbd_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 216d47b..a45a0d3 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1547,7 +1547,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 		old_conf = tconn->net_conf;
 		tconn->my_addr_len = 0;
 		tconn->peer_addr_len = 0;
-		rcu_assign_pointer(tconn->net_conf, NULL);
+		RCU_INIT_POINTER(tconn->net_conf, NULL);
 		conn_free_crypto(tconn);
 		mutex_unlock(&tconn->conf_update);
 
-- 
1.7.9.5

