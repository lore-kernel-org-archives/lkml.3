Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaGVF7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:59:06 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48655 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGVF7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:59:04 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: walken@google.com, akpm@linux-foundation.org,
        xiaoguangrong@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH] rbtree: fix typo in comment of __rb_insert()
Date: Tue, 22 Jul 2014 13:58:52 +0800
Message-Id: <1406008733-17186-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072205-4790-0000-0000-000002CF60D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case 1, it passes down the BLACK color from G to p and u, and maintains the
color of n. By doing so, it maintains the black height of the sub-tree.

While in the comment, it marks the color of n to BLACK. This is a typo and not
consistents with the code.

This patch fixs this typo in comment.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 lib/rbtree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 65f4eff..c16c81a 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -101,7 +101,7 @@ __rb_insert(struct rb_node *node, struct rb_root *root,
 				 *      / \          / \
 				 *     p   u  -->   P   U
 				 *    /            /
-				 *   n            N
+				 *   n            n
 				 *
 				 * However, since g's parent might be red, and
 				 * 4) does not allow this, we need to recurse
-- 
1.7.9.5

