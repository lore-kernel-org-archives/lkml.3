Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab3DLBTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:19:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50486 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3DLBOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:20 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 02/25] rbtree: add rbtree_postorder_for_each_entry_safe() helper.
Date: Thu, 11 Apr 2013 18:13:34 -0700
Message-Id: <1365729237-29711-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-5406-0000-0000-00000761080B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/rbtree.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 2879e96..1b239ca 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -85,4 +85,12 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 	*rb_link = node;
 }
 
+#define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
+	for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
+	      n = rb_entry(rb_next_postorder(&pos->field), \
+		      typeof(*pos), field); \
+	     &pos->field; \
+	     pos = n, \
+	      n = rb_entry(rb_next_postorder(&pos->field), typeof(*pos), field))
+
 #endif	/* _LINUX_RBTREE_H */
-- 
1.8.2.1

