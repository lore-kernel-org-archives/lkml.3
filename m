Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab3CLGuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:50:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:55790 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab3CLGuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:50:11 -0400
Message-ID: <513ED01D.5020200@huawei.com>
Date: Tue, 12 Mar 2013 14:50:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/8] cgroup: remove cgroup_is_descentant()
References: <513ED010.5060906@huawei.com>
In-Reply-To: <513ED010.5060906@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was used by ns cgroup, and ns cgroup was removed long ago.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  3 ---
 kernel/cgroup.c        | 28 ----------------------------
 2 files changed, 31 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5f76829..7e818a3 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -448,9 +448,6 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
-/* Return true if cgrp is a descendant of the task's cgroup */
-int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task);
-
 /*
  * Control Group taskset, used to pass around set of tasks to cgroup_subsys
  * methods.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e72c44e..02b02ca 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5036,34 +5036,6 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	put_css_set_taskexit(cg);
 }
 
-/**
- * cgroup_is_descendant - see if @cgrp is a descendant of @task's cgrp
- * @cgrp: the cgroup in question
- * @task: the task in question
- *
- * See if @cgrp is a descendant of @task's cgroup in the appropriate
- * hierarchy.
- *
- * If we are sending in dummytop, then presumably we are creating
- * the top cgroup in the subsystem.
- *
- * Called only by the ns (nsproxy) cgroup.
- */
-int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task)
-{
-	int ret;
-	struct cgroup *target;
-
-	if (cgrp == dummytop)
-		return 1;
-
-	target = task_cgroup_from_root(task, cgrp->root);
-	while (cgrp != target && cgrp!= cgrp->top_cgroup)
-		cgrp = cgrp->parent;
-	ret = (cgrp == target);
-	return ret;
-}
-
 static void check_for_release(struct cgroup *cgrp)
 {
 	/* All of these checks rely on RCU to keep the cgroup
-- 
1.8.0.2
