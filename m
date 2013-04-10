Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936446Ab3DJNrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:47:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59406 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760944Ab3DJNrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:47:37 -0400
Date: Wed, 10 Apr 2013 06:47:19 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-621e2de02403a6f776852c564b79c38bf3cc9032@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
In-Reply-To: <5155383F.8000005@huawei.com>
References: <5155383F.8000005@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpuacct:
  Initialize cpuacct subsystem earlier
Git-Commit-ID: 621e2de02403a6f776852c564b79c38bf3cc9032
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:47:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  621e2de02403a6f776852c564b79c38bf3cc9032
Gitweb:     http://git.kernel.org/tip/621e2de02403a6f776852c564b79c38bf3cc9032
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:44:15 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:21 +0200

sched/cpuacct: Initialize cpuacct subsystem earlier

Initialize cpuacct before the scheduler is functioning, so when
cpuacct_charge() and cpuacct_account_field() are called,
task_ca() won't return NULL.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5155383F.8000005@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cpuacct.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 0425581..75e46d2 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -292,9 +292,10 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 }
 
 struct cgroup_subsys cpuacct_subsys = {
-	.name = "cpuacct",
-	.css_alloc = cpuacct_css_alloc,
-	.css_free = cpuacct_css_free,
-	.subsys_id = cpuacct_subsys_id,
-	.base_cftypes = files,
+	.name		= "cpuacct",
+	.css_alloc	= cpuacct_css_alloc,
+	.css_free	= cpuacct_css_free,
+	.subsys_id	= cpuacct_subsys_id,
+	.base_cftypes	= files,
+	.early_init	= 1,
 };
