Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab3C2Uqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 16:46:31 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:39506 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3C2Uqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 16:46:30 -0400
Message-ID: <1364589989.13783.2.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v2 1/2] rbtree_test: add extra rbtree integrity check
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 29 Mar 2013 13:46:29 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account for the rbtree having  2**bh(v)-1 internal nodes.

While this can be seen as a consequence of other checks, Michel states
that it nicely sums up what the other properties are for.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 lib/rbtree_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index af38aed..9951503 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -117,8 +117,7 @@ static int black_path_count(struct rb_node *rb)
 static void check(int nr_nodes)
 {
 	struct rb_node *rb;
-	int count = 0;
-	int blacks = 0;
+	int count = 0, blacks = 0;
 	u32 prev_key = 0;
 
 	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
@@ -134,7 +133,9 @@ static void check(int nr_nodes)
 		prev_key = node->key;
 		count++;
 	}
+
 	WARN_ON_ONCE(count != nr_nodes);
+	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
 }
 
 static void check_augmented(int nr_nodes)
-- 
1.7.11.7




