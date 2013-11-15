Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3KOI64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:58:56 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47990 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab3KOI6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:58:48 -0500
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH TRIVIAL] sched: Fix comments in struct root_domain
Date: Fri, 15 Nov 2013 14:28:37 +0530
Message-Id: <1384505917-18366-1-git-send-email-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111508-1396-0000-0000-000003E0E258
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move comments related to RT overload, above rto_count.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/sched.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88c85b21d633..ca452e63f203 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -372,19 +372,18 @@ struct rt_rq {
  * fully partitioning the member cpus from any other cpuset. Whenever a new
  * exclusive cpuset is created, we also create and attach a new root-domain
  * object.
- *
  */
 struct root_domain {
 	atomic_t refcount;
-	atomic_t rto_count;
-	struct rcu_head rcu;
-	cpumask_var_t span;
-	cpumask_var_t online;
 
 	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
 	 * one runnable RT task.
 	 */
+	atomic_t rto_count;
+	struct rcu_head rcu;
+	cpumask_var_t span;
+	cpumask_var_t online;
 	cpumask_var_t rto_mask;
 	struct cpupri cpupri;
 };
-- 
1.8.4.474.g128a96c

