Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3KJQ6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:58:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3KJQ6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:58:41 -0500
Date: Sun, 10 Nov 2013 18:00:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eilon Greenstein <eilong@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] list: introduce list_next_entry() and list_prev_entry()
Message-ID: <20131110170004.GA304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131110165947.GA32758@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 2 trivial helpers list_next_entry() and list_prev_entry(),
they can have a lot of users including list.h itself. In fact
the 1st one is already defined in events/core.c and bnx2x_sp.c,
so the patch simply moves the definition to list.h.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |    3 ---
 include/linux/list.h                           |   16 ++++++++++++++++
 kernel/events/core.c                           |    3 ---
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 9fbeee5..32c92ab 100644
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
index f4d8a2f..2ece638 100644
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
index 953c143..8429d05 100644
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
1.5.5.1

