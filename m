Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3CEIIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:08:38 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64501 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3CEIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:08:36 -0500
Message-ID: <5135A7D8.7000107@huawei.com>
Date: Tue, 5 Mar 2013 16:07:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/9] sched: Remove double declaration of root_task_group
References: <5135A736.8050104@huawei.com>
In-Reply-To: <5135A736.8050104@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's already declared in include/linux/sched.h

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/core.c  | 4 ++++
 kernel/sched/sched.h | 5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9ad26c9..42ecbcb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6861,6 +6861,10 @@ int in_sched_functions(unsigned long addr)
 }
 
 #ifdef CONFIG_CGROUP_SCHED
+/*
+ * Default task group.
+ * Every task in system belongs to this group at bootup.
+ */
 struct task_group root_task_group;
 LIST_HEAD(task_groups);
 #endif
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 304fc1c..30bebb9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -179,11 +179,6 @@ struct task_group {
 #define MAX_SHARES	(1UL << 18)
 #endif
 
-/* Default task group.
- *	Every task in system belong to this group at bootup.
- */
-extern struct task_group root_task_group;
-
 typedef int (*tg_visitor)(struct task_group *, void *);
 
 extern int walk_tg_tree_from(struct task_group *from,
-- 
1.8.0.2
