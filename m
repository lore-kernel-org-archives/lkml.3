Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaKQVR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:17:28 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:45091 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaKQVR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:17:27 -0500
Date: Mon, 17 Nov 2014 16:17:23 -0500
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: move swp_entry_t definition to include/linux/mm_types.h
Message-ID: <20141117211723.GH23126@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swp_entry_t being defined in include/linux/swap.h instead of
include/linux/mm_types.h causes cyclic include dependency later when
include/linux/page_cgroup.h is included from writeback path.  Move the
definition to include/linux/mm_types.h.

While at it, reformat the comment above it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mm_types.h |    8 ++++++++
 include/linux/swap.h     |    8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -525,4 +525,12 @@ enum tlb_flush_reason {
 	NR_TLB_FLUSH_REASONS,
 };
 
+ /*
+  * A swap entry has to fit into a "unsigned long", as the entry is hidden
+  * in the "index" field of the swapper address space.
+  */
+typedef struct {
+	unsigned long val;
+} swp_entry_t;
+
 #endif /* _LINUX_MM_TYPES_H */
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -102,14 +102,6 @@ union swap_header {
 	} info;
 };
 
- /* A swap entry has to fit into a "unsigned long", as
-  * the entry is hidden in the "index" field of the
-  * swapper address space.
-  */
-typedef struct {
-	unsigned long val;
-} swp_entry_t;
-
 /*
  * current->reclaim_state points to one of these when a task is running
  * memory reclaim
