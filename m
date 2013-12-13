Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3LMOQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:16:38 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29473 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3LMOQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:16:37 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-b8-52ab16c20609
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v3] kernel/locking: mutex: simplify access to the first entry
 in the wait-list
Date: Fri, 13 Dec 2013 15:16:22 +0100
Message-id: <1386944182-24373-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMJMWRmVeSWpSXmKPExsVy+t/xq7qHxFYHGbSs0rOY9bKdxeJs0xt2
	i8u75rBZrD1yl93i0oEFTBbHew8wObB5bF6h5fF+31U2j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MrY/Xcbc8Fdjoo5/f+YGxinsncxcnJICJhIXHp3FMoWk7hwbz1bFyMXh5DAUkaJzSce
	gSWEBPqZJJ7cqQKx2QSMJfYe7GAEsUUEFCQ29z5jBWlgFrjGKPHzxxJWkISwQILEp0WbwGwW
	AVWJS+duMIPYvAKuErfu/GaC2CYv8fR+H9sERu4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS
	83M3MUIC4usOxqXHrA4xCnAwKvHw3uReHSTEmlhWXJl7iFGCg1lJhNeLDyjEm5JYWZValB9f
	VJqTWnyIkYmDU6qBsbntSXP7Gu23wgE30lt0DM9fdij60LPINqypfbYqsxWrwMsj/JVTlpSc
	navkci3Pvf+FSTnvV/6Id10v/MyVV+xjS9ghmL+yXSGqp+r+ipcRQlw9p92/qf25fjrBPHRS
	TgMfd4l91bEam7U8CQ8PX2LRVZ/h+Fn/ksqz1ZGX9EMcLKQMky2VWIozEg21mIuKEwEoMfY/
	5gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_first_entry instead of explicitly accessing the first entry
with "head".next. The comment one line above becomes obsolete.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---

v2..v3:

- changed Singed-off-by to Reviewed-by: Kyungmin Park

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

