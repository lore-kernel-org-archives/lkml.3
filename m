Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaHROXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:23:48 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:65007 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaHROXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:23:46 -0400
Date: Mon, 18 Aug 2014 17:23:33 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        erezsh@mellanox.com, mschmidt@redhat.com, ogerlitz@mellanox.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] ipoib: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818142333.GA1561@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
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
1.9.1

