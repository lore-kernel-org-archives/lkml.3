Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030414Ab3DSM02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:26:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21639 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030380Ab3DSM0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:26:22 -0400
Message-ID: <517137E7.20505@huawei.com>
Date: Fri, 19 Apr 2013 20:26:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 04/10] cpuset: remove cpuset_test_cpumask()
References: <517137A7.4020605@huawei.com>
In-Reply-To: <517137A7.4020605@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test is done in set_cpus_allowed_ptr(), so it's redundant.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 66302a9..8b0e433 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -783,23 +783,6 @@ void rebuild_sched_domains(void)
 }
 
 /**
- * cpuset_test_cpumask - test a task's cpus_allowed versus its cpuset's
- * @tsk: task to test
- * @scan: struct cgroup_scanner contained in its struct cpuset_hotplug_scanner
- *
- * Call with cpuset_mutex held.  May take callback_mutex during call.
- * Called for each task in a cgroup by cgroup_scan_tasks().
- * Return nonzero if this tasks's cpus_allowed mask should be changed (in other
- * words, if its mask is not equal to its cpuset's mask).
- */
-static int cpuset_test_cpumask(struct task_struct *tsk,
-			       struct cgroup_scanner *scan)
-{
-	return !cpumask_equal(&tsk->cpus_allowed,
-			(cgroup_cs(scan->cg))->cpus_allowed);
-}
-
-/**
  * cpuset_change_cpumask - make a task's cpus_allowed the same as its cpuset's
  * @tsk: task to test
  * @scan: struct cgroup_scanner containing the cgroup of the task
@@ -834,7 +817,7 @@ static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 	struct cgroup_scanner scan;
 
 	scan.cg = cs->css.cgroup;
-	scan.test_task = cpuset_test_cpumask;
+	scan.test_task = NULL;
 	scan.process_task = cpuset_change_cpumask;
 	scan.heap = heap;
 	cgroup_scan_tasks(&scan);
-- 
1.8.0.2
