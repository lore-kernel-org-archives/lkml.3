Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3LLJq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:46:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28769 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3LLJqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:46:54 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-63-52a9860c5c3c
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] kernel/locking: mutex: simplify access to the first entry in
 the wait-list
Date: Thu, 12 Dec 2013 10:45:41 +0100
Message-id: <1386841541-32244-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJMWRmVeSWpSXmKPExsVy+t/xa7o8bSuDDG4c5rOY9bKdxeJs0xt2
	i8u75rBZrD1yl93i0oEFTBbHew8wObB5bF6h5fF+31U2j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MrYNf0UW8EJ9op7N1ezNjAuZOti5OSQEDCRWDVjLxOELSZx4d56oDgXh5DAUkaJ/reX
	mCCcfiaJMy3nWEGq2ASMJfYe7GAEsUUEFCQ29z5jBSliFrjGKPHzxxKwImGBWIn2niXMIDaL
	gKrExG9LwRp4BVwlVj1fywyxTl7i6f0+tgmM3AsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn
	525ihITElx2Mi49ZHWIU4GBU4uF9cXBFkBBrYllxZe4hRgkOZiURXpfUlUFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGCf8ta0v2MWvuZ4r3oTx26u30T79+xSPntB5uvTB847P9TV7VBfFJ5XI
	rM2ZN3u7zk81q9q/8zTLnyZc7XxnsydV5IlC+b1IBYl9xuYlfxQnSRuHcux6va9DZNqe0Mt+
	DMFLTz/eyGfy8vWVrP9qIt8MMm4zHIrVkr8XUJH/y2bdmrorsW+3b1ZiKc5INNRiLipOBAB8
	/Yh55wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_first_entry instead of explicitly accessing the first entry
with "head".next. The comment one line above becomes obsolete.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <andrzej.p@samsung.com>
---
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

