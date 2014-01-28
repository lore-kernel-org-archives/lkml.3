Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaA1Rfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:35:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60577 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaA1Rdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:33:49 -0500
Message-Id: <20140128171948.217737555@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 Jan 2014 18:16:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6/9] sched/fair: Clean up __clear_buddies_*
References: <20140128171634.974847076@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slightly easier code flow, no functional changes.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2567,10 +2567,10 @@ static void __clear_buddies_last(struct
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->last == se)
-			cfs_rq->last = NULL;
-		else
+		if (cfs_rq->last != se)
 			break;
+
+		cfs_rq->last = NULL;
 	}
 }
 
@@ -2578,10 +2578,10 @@ static void __clear_buddies_next(struct
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->next == se)
-			cfs_rq->next = NULL;
-		else
+		if (cfs_rq->next != se)
 			break;
+
+		cfs_rq->next = NULL;
 	}
 }
 
@@ -2589,10 +2589,10 @@ static void __clear_buddies_skip(struct
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->skip == se)
-			cfs_rq->skip = NULL;
-		else
+		if (cfs_rq->skip != se)
 			break;
+
+		cfs_rq->skip = NULL;
 	}
 }
 


