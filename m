Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaISLqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:46:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbaISLqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:46:12 -0400
Date: Fri, 19 Sep 2014 04:45:17 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-a8edd075323cec607797fdd1d7b1222c987f4a47@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1410529276.3569.24.camel@tkhai>
References: <1410529276.3569.24.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: cleanup:
  Remove useless assignment in select_task_rq_fair()
Git-Commit-ID: a8edd075323cec607797fdd1d7b1222c987f4a47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8edd075323cec607797fdd1d7b1222c987f4a47
Gitweb:     http://git.kernel.org/tip/a8edd075323cec607797fdd1d7b1222c987f4a47
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Fri, 12 Sep 2014 17:41:16 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:18 +0200

sched/fair: cleanup: Remove useless assignment in select_task_rq_fair()

new_cpu is reassigned below, so we do not need this here.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1410529276.3569.24.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 96e7147..9807a99 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4521,11 +4521,8 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
 
-	if (sd_flag & SD_BALANCE_WAKE) {
-		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
-			want_affine = 1;
-		new_cpu = prev_cpu;
-	}
+	if (sd_flag & SD_BALANCE_WAKE)
+		want_affine = cpumask_test_cpu(cpu, tsk_cpus_allowed(p));
 
 	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
