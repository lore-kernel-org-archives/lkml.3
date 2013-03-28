Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab3C1HWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:22:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44128 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab3C1HWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:22:13 -0400
Message-ID: <5153EF7B.1020403@huawei.com>
Date: Thu, 28 Mar 2013 15:21:31 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 4/5] cpuacct: No need to check subsys active state
References: <5153EF24.3040608@huawei.com>
In-Reply-To: <5153EF24.3040608@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we're guaranteed when cpuacct_charge() and cpuacct_account_field()
are called, cpuacct has already been properly initialized, so we no
longer need those checks.

Signed-off-by: Li Zefan <lizefan@huawei.com>
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
-- 
1.8.0.2
