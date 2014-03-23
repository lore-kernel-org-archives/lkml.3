Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946AbaCWS0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:26:24 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49356 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCWS0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:26:22 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        ogerlitz@mellanox.com, mschmidt@redhat.com, erezsh@mellanox.com,
        jinpu.wang@profitbricks.com, dledford@redhat.com, foraker1@llnl.gov,
        kaber@trash.net, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/infiniband: Use RCU_INIT_POINTER(x, NULL) in ulp/ipoib/ipoib_main.c
Date: Sun, 23 Mar 2014 23:55:19 +0530
Message-Id: <1395599119-6731-1-git-send-email-monamagarwal123@gmail.com>
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
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 5786a78..64cd5b5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1229,7 +1229,7 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 	}
 
 free_htbl:
-	rcu_assign_pointer(ntbl->htbl, NULL);
+	RCU_INIT_POINTER(ntbl->htbl, NULL);
 	call_rcu(&htbl->rcu, neigh_hash_free_rcu);
 
 out_unlock:
-- 
1.7.9.5

