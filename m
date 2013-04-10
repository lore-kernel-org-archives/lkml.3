Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936388Ab3DJNsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:48:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3DJNsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:48:45 -0400
Date: Wed, 10 Apr 2013 06:48:32 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-a2b0ae25fc8bfeeb4022b8e847ab811b3c8368d1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
In-Reply-To: <5155384C.7000508@huawei.com>
References: <5155384C.7000508@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpuacct:
  No need to check subsys active state
Git-Commit-ID: a2b0ae25fc8bfeeb4022b8e847ab811b3c8368d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:48:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2b0ae25fc8bfeeb4022b8e847ab811b3c8368d1
Gitweb:     http://git.kernel.org/tip/a2b0ae25fc8bfeeb4022b8e847ab811b3c8368d1
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:44:28 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:22 +0200

sched/cpuacct: No need to check subsys active state

Now we're guaranteed when cpuacct_charge() and
cpuacct_account_field() are called, cpuacct has already been
properly initialized, so we no longer need those checks.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5155384C.7000508@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cpuacct.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 75e46d2..ef57ab6 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -247,9 +247,6 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	struct cpuacct *ca;
 	int cpu;
 
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
 	cpu = task_cpu(tsk);
 
 	rcu_read_lock();
@@ -278,9 +275,6 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 	struct kernel_cpustat *kcpustat;
 	struct cpuacct *ca;
 
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
 	rcu_read_lock();
 	ca = task_ca(p);
 	while (ca != &root_cpuacct) {
