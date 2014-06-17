Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833AbaFQQTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:19:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50613 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933976AbaFQQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:18:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Eilon Greenstein <eilong@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 047/121] list: introduce list_next_entry() and list_prev_entry()
Date: Tue, 17 Jun 2014 09:17:05 -0700
Message-Id: <1403021899-16708-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 008208c6b26f21c2648c250a09c55e737c02c5f8 ]

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |  3 ---
 include/linux/list.h                           | 16 ++++++++++++++++
 kernel/events/core.c                           |  3 ---
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 09b625e..faabbab 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -1032,9 +1032,6 @@ static void bnx2x_set_one_vlan_mac_e1h(struct bnx2x *bp,
 				     ETH_VLAN_FILTER_CLASSIFY, config);
 }
 
-#define list_next_entry(pos, member) \
-	list_entry((pos)->member.next, typeof(*(pos)), member)
-
 /**
  * bnx2x_vlan_mac_restore - reconfigure next MAC/VLAN/VLAN-MAC element
  *
diff --git a/include/linux/list.h b/include/linux/list.h
index cc6d2aa..1712c7e 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -362,6 +362,22 @@ static inline void list_splice_tail_init(struct list_head *list,
 	list_entry((ptr)->next, type, member)
 
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
index 108aa71..21b70df 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1978,9 +1978,6 @@ static void __perf_event_sync_stat(struct perf_event *event,
 	perf_event_update_userpage(next_event);
 }
 
-#define list_next_entry(pos, member) \
-	list_entry(pos->member.next, typeof(*pos), member)
-
 static void perf_event_sync_stat(struct perf_event_context *ctx,
 				   struct perf_event_context *next_ctx)
 {
-- 
1.9.1

