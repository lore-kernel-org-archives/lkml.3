Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbaFCLmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:42:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43713 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbaFCLmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Eilon Greenstein <eilong@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 094/138] list: introduce list_next_entry() and list_prev_entry()
Date: Tue,  3 Jun 2014 12:39:00 +0100
Message-Id: <1401795584-22664-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |  3 ---
 include/linux/list.h                           | 16 ++++++++++++++++
 kernel/events/core.c                           |  3 ---
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 8f03c984550f..859555465385 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -1020,9 +1020,6 @@ static void bnx2x_set_one_vlan_mac_e1h(struct bnx2x *bp,
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
index e07429197ece..9c511b4296db 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2207,9 +2207,6 @@ static void __perf_event_sync_stat(struct perf_event *event,
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

