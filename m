Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab3CFOnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:43:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44357 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab3CFOnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:43:43 -0500
Date: Wed, 6 Mar 2013 06:42:27 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-27b4b9319a3c2e8654d45df99ce584c7c2cfe100@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5135A7D8.7000107@huawei.com>
References: <5135A7D8.7000107@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Remove double declaration of root_task_group
Git-Commit-ID: 27b4b9319a3c2e8654d45df99ce584c7c2cfe100
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:42:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27b4b9319a3c2e8654d45df99ce584c7c2cfe100
Gitweb:     http://git.kernel.org/tip/27b4b9319a3c2e8654d45df99ce584c7c2cfe100
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 16:07:52 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:24:35 +0100

sched: Remove double declaration of root_task_group

It's already declared in include/linux/sched.h

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5135A7D8.7000107@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
