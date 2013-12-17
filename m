Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3LQMqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:46:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41639 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LQMqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:46:07 -0500
Message-Id: <20131217123352.858775348@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Dec 2013 13:27:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 04/13] [PATCH 05/13] sched: SCHED_DEADLINE avg_update accounting
References: <20131217122720.950475833@infradead.org>
Content-Disposition: inline; filename=0005-sched-SCHED_DEADLINE-avg_update-accounting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Make the core scheduler and load balancer aware of the load
produced by -deadline tasks, by updating the moving average
like for sched_rt.

Cc: bruce.ashfield@windriver.com
Cc: claudio@evidence.eu.com
Cc: darren@dvhart.com
Cc: dhaval.giani@gmail.com
Cc: fchecconi@gmail.com
Cc: fweisbec@gmail.com
Cc: harald.gustafsson@ericsson.com
Cc: hgu1972@gmail.com
Cc: insop.song@gmail.com
Cc: jkacur@redhat.com
Cc: johan.eker@ericsson.com
Cc: liming.wang@windriver.com
Cc: luca.abeni@unitn.it
Cc: michael@amarulasolutions.com
Cc: mingo@redhat.com
Cc: nicola.manica@disi.unitn.it
Cc: oleg@redhat.com
Cc: paulmck@linux.vnet.ibm.com
Cc: p.faure@akatech.ch
Cc: rostedt@goodmis.org
Cc: tglx@linutronix.de
Cc: tommaso.cucinotta@sssup.it
Cc: vincent.guittot@linaro.org
Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/deadline.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ab5deb9..e69b4e0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -564,6 +564,8 @@ static void update_curr_dl(struct rq *rq)
 	curr->se.exec_start = rq_clock_task(rq);
 	cpuacct_charge(curr, delta_exec);
 
+	sched_rt_avg_update(rq, delta_exec);
+
 	dl_se->runtime -= delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
-- 
1.7.10.4



