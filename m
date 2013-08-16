Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3HPSrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:47:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab3HPSrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:47:12 -0400
Date: Fri, 16 Aug 2013 11:46:35 -0700
From: tip-bot for Christoph Lameter <tipbot@zytor.com>
Message-ID: <tip-a4f61cc03e443647211a5ae0ab8f8cda2e9e1043@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, cl@gentwo.org, cl@linux.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, cl@gentwo.org, tglx@linutronix.de, cl@linux.com
In-Reply-To: <00000140596dd165-338ff7f5-893b-4fec-b251-aaac5557239e-000000@email.amazonses.com>
References: <00000140596dd165-338ff7f5-893b-4fec-b251-aaac5557239e-000000@email.amazonses.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cputime: Use this_cpu_add()
  in task_group_account_field()
Git-Commit-ID: a4f61cc03e443647211a5ae0ab8f8cda2e9e1043
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Aug 2013 11:46:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4f61cc03e443647211a5ae0ab8f8cda2e9e1043
Gitweb:     http://git.kernel.org/tip/a4f61cc03e443647211a5ae0ab8f8cda2e9e1043
Author:     Christoph Lameter <cl@gentwo.org>
AuthorDate: Wed, 7 Aug 2013 15:38:24 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Aug 2013 17:44:29 +0200

sched/cputime: Use this_cpu_add() in task_group_account_field()

Use of a this_cpu() operation reduces the number of instructions used
for accounting (account_user_time()) and frees up some registers. This is in
the scheduler tick hotpath.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/00000140596dd165-338ff7f5-893b-4fec-b251-aaac5557239e-000000@email.amazonses.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cputime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a7959e0..e89ccef 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -121,7 +121,7 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	 * is the only cgroup, then nothing else should be necessary.
 	 *
 	 */
-	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
+	__this_cpu_add(kernel_cpustat.cpustat[index], tmp);
 
 	cpuacct_account_field(p, index, tmp);
 }
