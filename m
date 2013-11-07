Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3KGNqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:46:50 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64903 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3KGNoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:44:30 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com
Subject: [PATCH 05/14] sched: SCHED_DEADLINE avg_update accounting.
Date: Thu,  7 Nov 2013 14:43:39 +0100
Message-Id: <1383831828-15501-6-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Make the core scheduler and load balancer aware of the load
produced by -deadline tasks, by updating the moving average
like for sched_rt.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/deadline.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 18a73b4..2cd5a22 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -562,6 +562,8 @@ static void update_curr_dl(struct rq *rq)
 	curr->se.exec_start = rq_clock_task(rq);
 	cpuacct_charge(curr, delta_exec);
 
+	sched_rt_avg_update(rq, delta_exec);
+
 	dl_se->runtime -= delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
-- 
1.7.9.5

