Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab3HWOra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 10:47:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51349 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3HWOr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 10:47:28 -0400
From: zwu.kernel@gmail.com
To: linux-kernel@vger.kernel.org
Cc: walken@google.com, akpm@linux-foundation.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] rbtree: Add some necessary condition checks
Date: Fri, 23 Aug 2013 22:45:06 +0800
Message-Id: <1377269106-26468-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082314-5406-0000-0000-00000BB4F2D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 include/linux/rbtree_augmented.h | 3 ++-
 lib/rbtree.c                     | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
index fea49b5..7d19770 100644
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -199,7 +199,8 @@ __rb_erase_augmented(struct rb_node *node, struct rb_root *root,
 		}
 
 		successor->rb_left = tmp = node->rb_left;
-		rb_set_parent(tmp, successor);
+		if (tmp)
+			rb_set_parent(tmp, successor);
 
 		pc = node->__rb_parent_color;
 		tmp = __rb_parent(pc);
diff --git a/lib/rbtree.c b/lib/rbtree.c
index c0e31fe..2cb01ba 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -214,7 +214,7 @@ ____rb_erase_color(struct rb_node *parent, struct rb_root *root,
 		 */
 		sibling = parent->rb_right;
 		if (node != sibling) {	/* node == parent->rb_left */
-			if (rb_is_red(sibling)) {
+			if (sibling && rb_is_red(sibling)) {
 				/*
 				 * Case 1 - left rotate at parent
 				 *
@@ -226,7 +226,8 @@ ____rb_erase_color(struct rb_node *parent, struct rb_root *root,
 				 */
 				parent->rb_right = tmp1 = sibling->rb_left;
 				sibling->rb_left = parent;
-				rb_set_parent_color(tmp1, parent, RB_BLACK);
+				if (tmp1)
+					rb_set_parent_color(tmp1, parent, RB_BLACK);
 				__rb_rotate_set_parents(parent, sibling, root,
 							RB_RED);
 				augment_rotate(parent, sibling);
-- 
1.7.11.7

