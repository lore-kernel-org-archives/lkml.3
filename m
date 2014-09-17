Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaIQC0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:26:17 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55286 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754978AbaIQC0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:26:15 -0400
X-IronPort-AV: E=Sophos;i="5.04,537,1406563200"; 
   d="scan'208";a="36055901"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH] rbtree: add comment to rb_insert_augmented()
Date: Wed, 17 Sep 2014 10:25:34 +0800
Message-ID: <1410920735-5767-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment is copied from Documentation/rbtree.txt, but this comment
is so important that it should also be in the code.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Michel Lespinasse <walken@google.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/rbtree_augmented.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
index fea49b5..378c5ee 100644
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -43,6 +43,16 @@ struct rb_augment_callbacks {
 
 extern void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
+/*
+ * Fixup the rbtree and update the augmented information when rebalancing.
+ *
+ * On insertion, the user must update the augmented information on the path
+ * leading to the inserted node, then call rb_link_node() as usual and
+ * rb_augment_inserted() instead of the usual rb_insert_color() call.
+ * If rb_augment_inserted() rebalances the rbtree, it will callback into
+ * a user provided function to update the augmented information on the
+ * affected subtrees.
+ */
 static inline void
 rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 		    const struct rb_augment_callbacks *augment)
-- 
1.7.4.4

