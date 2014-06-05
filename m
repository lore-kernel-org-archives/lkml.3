Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaFEETu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:19:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaFEETt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:19:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 014/214] list: introduce list_next_entry() and list_prev_entry()
Date: Wed,  4 Jun 2014 21:16:17 -0700
Message-Id: <20140605041641.687399396@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |    3 ---
 include/linux/list.h                           |   16 ++++++++++++++++
 kernel/events/core.c                           |    3 ---
 3 files changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -1030,9 +1030,6 @@ static void bnx2x_set_one_vlan_mac_e1h(s
 				     ETH_VLAN_FILTER_CLASSIFY, config);
 }
 
-#define list_next_entry(pos, member) \
-	list_entry((pos)->member.next, typeof(*(pos)), member)
-
 /**
  * bnx2x_vlan_mac_restore - reconfigure next MAC/VLAN/VLAN-MAC element
  *
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -362,6 +362,22 @@ static inline void list_splice_tail_init
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
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1973,9 +1973,6 @@ static void __perf_event_sync_stat(struc
 	perf_event_update_userpage(next_event);
 }
 
-#define list_next_entry(pos, member) \
-	list_entry(pos->member.next, typeof(*pos), member)
-
 static void perf_event_sync_stat(struct perf_event_context *ctx,
 				   struct perf_event_context *next_ctx)
 {


