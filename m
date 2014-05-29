Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591AbaE2N7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:59:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59464 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933434AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 016/103] list: introduce list_next_entry() and list_prev_entry()
Date: Thu, 29 May 2014 15:48:01 +0200
Message-Id: <99565b6c9eb1ae28ab633d7104e654e6dc6a6679.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 008208c6b26f21c2648c250a09c55e737c02c5f8 upstream.

Add two trivial helpers list_next_entry() and list_prev_entry(), they
can have a lot of users including list.h itself.  In fact the 1st one is
already defined in events/core.c and bnx2x_sp.c, so the patch simply
moves the definition to list.h.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |  3 ---
 include/linux/list.h                           | 16 ++++++++++++++++
 kernel/events/core.c                           |  3 ---
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 9fbeee522d2c..32c92abf5094 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -1217,9 +1217,6 @@ static void bnx2x_set_one_vlan_mac_e1h(struct bnx2x *bp,
 				     ETH_VLAN_FILTER_CLASSIFY, config);
 }
 
-#define list_next_entry(pos, member) \
-	list_entry((pos)->member.next, typeof(*(pos)), member)
-
 /**
  * bnx2x_vlan_mac_restore - reconfigure next MAC/VLAN/VLAN-MAC element
  *
diff --git a/include/linux/list.h b/include/linux/list.h
index f4d8a2f12a33..2ece63847001 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -373,6 +373,22 @@ static inline void list_splice_tail_init(struct list_head *list,
 	(!list_empty(ptr) ? list_first_entry(ptr, type, member) : NULL)
 
 /**
+ * list_next_entry - get the next element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_next_entry(pos, member) \
+	list_entry((pos)->member.next, typeof(*(pos)), member)
+
+/**
+ * list_prev_entry - get the prev element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_prev_entry(pos, member) \
+	list_entry((pos)->member.prev, typeof(*(pos)), member)
+
+/**
  * list_for_each	-	iterate over a list
  * @pos:	the &struct list_head to use as a loop cursor.
  * @head:	the head for your list.
diff --git a/kernel/events/core.c b/kernel/events/core.c
index fea4f6cf7e90..6c318bc71be5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2210,9 +2210,6 @@ static void __perf_event_sync_stat(struct perf_event *event,
 	perf_event_update_userpage(next_event);
 }
 
-#define list_next_entry(pos, member) \
-	list_entry(pos->member.next, typeof(*pos), member)
-
 static void perf_event_sync_stat(struct perf_event_context *ctx,
 				   struct perf_event_context *next_ctx)
 {
-- 
1.9.3

