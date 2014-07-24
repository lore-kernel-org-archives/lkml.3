Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671AbaGXUUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:20:49 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55413 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:20:48 -0400
Date: Fri, 25 Jul 2014 01:50:41 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] net_sched: remove exceptional & on function name
Message-ID: <20140724202040.GA16310@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this file, function names are otherwise used as pointers without &.

A simplified version of the Coccinelle semantic patch that makes this
change is as follows: 

// <smpl>
@r@
identifier f;
@@

f(...) { ... }

@@
identifier r.f;
@@

- &f
+ f
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 net/sched/cls_tcindex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index c721cd4..3e9f764 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -420,7 +420,7 @@ static void tcindex_destroy(struct tcf_proto *tp)
 	pr_debug("tcindex_destroy(tp %p),p %p\n", tp, p);
 	walker.count = 0;
 	walker.skip = 0;
-	walker.fn = &tcindex_destroy_element;
+	walker.fn = tcindex_destroy_element;
 	tcindex_walk(tp, &walker);
 	kfree(p->perfect);
 	kfree(p->h);
-- 
1.9.1

