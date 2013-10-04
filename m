Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3JDTZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:25:42 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48683 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3JDTZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:25:40 -0400
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <mgalbraith@suse.de>, tomk@rgmadvisors.com,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH] sched/rt: Remove redundant nr_cpus_allowed test
Date: Fri,  4 Oct 2013 14:24:53 -0500
Message-Id: <1380914693-24634-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <sbohrer@rgmadvisors.com>

In 76854c7e8f3f4172fef091e78d88b3b751463ac6 "sched: Use
rt.nr_cpus_allowed to recover select_task_rq() cycles" an optimization
was added to select_task_rq_rt() that immediately returns when
p->nr_cpus_allowed == 1 at the beginning of the function.  This makes
the latter p->nr_cpus_allowed > 1 check redundant and can be removed.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 kernel/sched/rt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 01970c8..ceebfba 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1213,8 +1213,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->nr_cpus_allowed < 2 ||
-	     curr->prio <= p->prio) &&
-	    (p->nr_cpus_allowed > 1)) {
+	     curr->prio <= p->prio)) {
 		int target = find_lowest_rq(p);
 
 		if (target != -1)
-- 
1.8.1.4

