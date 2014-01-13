Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaAMPyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:54:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbaAMPyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:54:19 -0500
Date: Mon, 13 Jan 2014 07:53:47 -0800
From: tip-bot for Dario Faggioli <tipbot@zytor.com>
Message-ID: <tip-239be4a982154ea0c979fca5846349bb68973aed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, raistlin@linux.it,
        juri.lelli@gmail.com
In-Reply-To: <1383831828-15501-6-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-6-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Add SCHED_DEADLINE avg_update accounting
Git-Commit-ID: 239be4a982154ea0c979fca5846349bb68973aed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:53:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  239be4a982154ea0c979fca5846349bb68973aed
Gitweb:     http://git.kernel.org/tip/239be4a982154ea0c979fca5846349bb68973aed
Author:     Dario Faggioli <raistlin@linux.it>
AuthorDate: Thu, 7 Nov 2013 14:43:39 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:41:08 +0100

sched/deadline: Add SCHED_DEADLINE avg_update accounting

Make the core scheduler and load balancer aware of the load
produced by -deadline tasks, by updating the moving average
like for sched_rt.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1383831828-15501-6-git-send-email-juri.lelli@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fcc02c9..21f58d2 100644
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
