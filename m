Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaAPNk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:40:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38450 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbaAPNkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:40:52 -0500
Date: Thu, 16 Jan 2014 05:40:21 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e3de300d1212b42aa9d0d6031b12fca06ac00dd9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de,
        daniel.lezcano@linaro.org
In-Reply-To: <20140115113015.GB31570@twins.programming.kicks-ass.net>
References: <20140115113015.GB31570@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Preserve the nice level over sched_setscheduler() and sched_setparam()
  calls
Git-Commit-ID: e3de300d1212b42aa9d0d6031b12fca06ac00dd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:40:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3de300d1212b42aa9d0d6031b12fca06ac00dd9
Gitweb:     http://git.kernel.org/tip/e3de300d1212b42aa9d0d6031b12fca06ac00dd9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 15 Jan 2014 12:30:15 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:27:14 +0100

sched: Preserve the nice level over sched_setscheduler() and sched_setparam() calls

Previously sched_setscheduler() and sched_setparam() would not affect
the nice value of a task, restore this behaviour.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: raistlin@linux.it
Cc: juri.lelli@gmail.com
Cc: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Fixes: d50dde5a10f3 ("sched: Add new scheduler syscalls to support an extended scheduling parameters ABI")
Link: http://lkml.kernel.org/r/20140115113015.GB31570@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26af370..c1b3d7e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3451,7 +3451,8 @@ int sched_setscheduler(struct task_struct *p, int policy,
 {
 	struct sched_attr attr = {
 		.sched_policy   = policy,
-		.sched_priority = param->sched_priority
+		.sched_priority = param->sched_priority,
+		.sched_nice	= PRIO_TO_NICE(p->static_prio),
 	};
 	return __sched_setscheduler(p, &attr, true);
 }
@@ -3481,7 +3482,8 @@ int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 {
 	struct sched_attr attr = {
 		.sched_policy   = policy,
-		.sched_priority = param->sched_priority
+		.sched_priority = param->sched_priority,
+		.sched_nice	= PRIO_TO_NICE(p->static_prio),
 	};
 	return __sched_setscheduler(p, &attr, false);
 }
