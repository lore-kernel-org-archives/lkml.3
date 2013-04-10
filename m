Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936170Ab3DJNpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:45:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab3DJNpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:45:14 -0400
Date: Wed, 10 Apr 2013 06:44:56 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-7943e15a3e91db78a7a3fbc84e45cf9d1c7c7d23@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
In-Reply-To: <51553822.5000403@huawei.com>
References: <51553822.5000403@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpuacct:
  Allocate per_cpu cpuusage for root cpuacct statically
Git-Commit-ID: 7943e15a3e91db78a7a3fbc84e45cf9d1c7c7d23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:45:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7943e15a3e91db78a7a3fbc84e45cf9d1c7c7d23
Gitweb:     http://git.kernel.org/tip/7943e15a3e91db78a7a3fbc84e45cf9d1c7c7d23
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:43:46 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:20 +0200

sched/cpuacct: Allocate per_cpu cpuusage for root cpuacct statically

This is a preparation, so later we can initialize cpuacct
earlier.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/51553822.5000403@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cpuacct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 9305fd2..a691c4d 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -58,6 +58,7 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 	return cgroup_ca(ca->css.cgroup->parent);
 }
 
+static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
 static struct cpuacct root_cpuacct;
 
 /* create a new cpu accounting group */
@@ -290,8 +291,7 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 void __init cpuacct_init(void)
 {
 	root_cpuacct.cpustat = &kernel_cpustat;
-	root_cpuacct.cpuusage = alloc_percpu(u64);
-	BUG_ON(!root_cpuacct.cpuusage); /* Too early, not expected to fail */
+	root_cpuacct.cpuusage = &root_cpuacct_cpuusage;
 }
 
 struct cgroup_subsys cpuacct_subsys = {
