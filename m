Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3C1HVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:21:36 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:43569 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab3C1HVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:21:35 -0400
Message-ID: <5153EF49.5040502@huawei.com>
Date: Thu, 28 Mar 2013 15:20:41 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/5] cpuacct: Allocate per_cpu cpuusage for root cpuacct statically
References: <5153EF24.3040608@huawei.com>
In-Reply-To: <5153EF24.3040608@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation, so later we can initialize cpuacct earlier.

Signed-off-by: Li Zefan <lizefan@huawei.com>
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
-- 
1.8.0.2
