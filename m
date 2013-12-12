Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3LLL3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:29:41 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34959 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3LLL3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:29:40 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-fa-52a99e226dde
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2] kernel/locking: mutex: simplify access to the first entry
 in the wait-list
Date: Thu, 12 Dec 2013 12:29:32 +0100
Message-id: <1386847772-8918-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJMWRmVeSWpSXmKPExsVy+t/xq7pK81YGGbQuYLeY9bKdxeJs0xt2
	i8u75rBZrD1yl93i0oEFTBbHew8wObB5bF6h5fF+31U2j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mq4fvk3U8FsjoqOqxMZGxgfsnUxcnJICJhI/J3WyQRhi0lcuLceKM7FISSwlFHi5Y1N
	UE4/k0RrzzawKjYBY4m9BzsYQWwRAQWJzb3PWEGKmAWuMUr8/LGEFSQhLJAg8bL/HDOIzSKg
	KtGx8xlYM6+Ai8T/lk4WiHXyEk/v97FNYORewMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93
	EyMkJL7uYFx6zOoQowAHoxIP74uDK4KEWBPLiitzDzFKcDArifC6pK4MEuJNSaysSi3Kjy8q
	zUktPsTIxMEp1cDIbB/z81eULaOF0OETLxffmfFeV2iWuvr+/BMHUxMneC1ozml4sFb38aaG
	yGnCfU9Xbtw/V8ziwoPYZW6unC1/WqKXzDjI+ND78IbFKn3GQb6/erj+uXZm8TF88vX+dary
	9wyD0+s7RdoPF8mIxtzd/jHsipb9TuUt8jt8QxuY3DMiJBz8GhuUWIozEg21mIuKEwGxRQp3
	5wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_first_entry instead of explicitly accessing the first entry
with "head".next. The comment one line above becomes obsolete.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

v1..v2:

- corrected the email address in the second Signed-off-by line

 kernel/locking/mutex.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4dd6e4c..4af4f9c 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -730,10 +730,9 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 		atomic_set(&lock->count, 1);
 
 	if (!list_empty(&lock->wait_list)) {
-		/* get the first entry from the wait-list: */
 		struct mutex_waiter *waiter =
-				list_entry(lock->wait_list.next,
-					   struct mutex_waiter, list);
+				list_first_entry(&lock->wait_list,
+						 struct mutex_waiter, list);
 
 		debug_mutex_wake_waiter(lock, waiter);
 
-- 
1.7.0.4

