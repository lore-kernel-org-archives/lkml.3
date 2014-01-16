Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaAPNkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:40:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaAPNkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:40:20 -0500
Date: Thu, 16 Jan 2014 05:39:51 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-d8bf52311ecefd9b11a5af2b28ed7f41c6023516@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
        juri.lelli@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Remove unused variables
Git-Commit-ID: d8bf52311ecefd9b11a5af2b28ed7f41c6023516
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:39:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8bf52311ecefd9b11a5af2b28ed7f41c6023516
Gitweb:     http://git.kernel.org/tip/d8bf52311ecefd9b11a5af2b28ed7f41c6023516
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 14 Jan 2014 11:23:34 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:27:10 +0100

sched/deadline: Remove unused variables

fix these new sparse warnings:

  >> kernel/sched/core.c:305:14: sparse: symbol 'sysctl_sched_dl_period' was not declared. Should it be static?
  >> kernel/sched/core.c:306:5: sparse: symbol 'sysctl_sched_dl_runtime' was not declared. Should it be static?

Better still, they're completely unused so remove them.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Link: http://lkml.kernel.org/n/tip-ke0shkG7vMnzmcdqhhiymyem@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0326c06..138711b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -297,17 +297,6 @@ __read_mostly int scheduler_running;
 int sysctl_sched_rt_runtime = 950000;
 
 /*
- * Maximum bandwidth available for all -deadline tasks and groups
- * (if group scheduling is configured) on each CPU.
- *
- * default: 5%
- */
-unsigned int sysctl_sched_dl_period = 1000000;
-int sysctl_sched_dl_runtime = 50000;
-
-
-
-/*
  * __task_rq_lock - lock the rq @p resides on.
  */
 static inline struct rq *__task_rq_lock(struct task_struct *p)
