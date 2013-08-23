Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3HWPF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:05:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40851 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3HWPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:05:55 -0400
From: zwu.kernel@gmail.com
To: linux-kernel@vger.kernel.org
Cc: walken@google.com, akpm@linux-foundation.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] rbtree: Add some necessary condition checks
Date: Fri, 23 Aug 2013 23:01:27 +0800
Message-Id: <1377270087-8669-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082315-9332-0000-0000-00000130388A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 include/linux/rbtree_augmented.h | 3 ++-
 lib/rbtree.c                     | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

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
index c0e31fe..329f2bc 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
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

