Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3JMLuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 07:50:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40225 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3JMLug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 07:50:36 -0400
From: baker.kernel@gmail.com
To: davem@davemloft.net, eric.dumazet@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "baker.zhang" <baker.kernel@gmail.com>
Subject: [PATCH v2 net-next] fib_trie: remove duplicated rcu lock
Date: Sun, 13 Oct 2013 19:50:09 +0800
Message-Id: <1381665009-4436-1-git-send-email-baker.kernel@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381636737.3392.29.camel@edumazet-glaptop.roam.corp.google.com>
References: <1381636737.3392.29.camel@edumazet-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "baker.zhang" <baker.kernel@gmail.com>

fib_table_lookup has included the rcu lock protection.

Signed-off-by: baker.zhang <baker.kernel@gmail.com>
---
Thanks for Eric Dumazet's review.
The V1 patch remove a necessary rcu read lock.

 net/ipv4/fib_frontend.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b3f627a..d846304 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -933,7 +933,6 @@ static void nl_fib_lookup(struct fib_result_nl *frn, struct fib_table *tb)
 		local_bh_disable();
 
 		frn->tb_id = tb->tb_id;
-		rcu_read_lock();
 		frn->err = fib_table_lookup(tb, &fl4, &res, FIB_LOOKUP_NOREF);
 
 		if (!frn->err) {
@@ -942,7 +941,6 @@ static void nl_fib_lookup(struct fib_result_nl *frn, struct fib_table *tb)
 			frn->type = res.type;
 			frn->scope = res.scope;
 		}
-		rcu_read_unlock();
 		local_bh_enable();
 	}
 }
-- 
1.8.1.2

