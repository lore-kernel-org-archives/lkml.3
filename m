Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3FEJQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:16:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:16296 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3FEJQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:16:25 -0400
Message-ID: <51AF01B7.3010102@huawei.com>
Date: Wed, 5 Jun 2013 17:15:35 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH v2 03/10] cpuset: remove unnecessary variable in cpuset_attach()
References: <51AF0183.8070602@huawei.com>
In-Reply-To: <51AF0183.8070602@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can just use oldcs->mems_allowed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d753837..dbef832 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1407,8 +1407,7 @@ static cpumask_var_t cpus_attach;
 
 static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 {
-	/* static bufs protected by cpuset_mutex */
-	static nodemask_t cpuset_attach_nodemask_from;
+	/* static buf protected by cpuset_mutex */
 	static nodemask_t cpuset_attach_nodemask_to;
 	struct mm_struct *mm;
 	struct task_struct *task;
@@ -1442,13 +1441,12 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	 * Change mm, possibly for multiple threads in a threadgroup. This is
 	 * expensive and may sleep.
 	 */
-	cpuset_attach_nodemask_from = oldcs->mems_allowed;
 	cpuset_attach_nodemask_to = cs->mems_allowed;
 	mm = get_task_mm(leader);
 	if (mm) {
 		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &cpuset_attach_nodemask_from,
+			cpuset_migrate_mm(mm, &oldcs->mems_allowed,
 					  &cpuset_attach_nodemask_to);
 		mmput(mm);
 	}
-- 
1.8.0.2
