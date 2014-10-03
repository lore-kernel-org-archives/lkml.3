Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaJCF3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:29:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaJCF27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:28:59 -0400
Date: Thu, 2 Oct 2014 22:28:07 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-10a12983b3d437a6998b3845870e52c1c752c101@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
In-Reply-To: <20140930210441.5258.55054.stgit@localhost>
References: <20140930210441.5258.55054.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Delete resched_cpu()
  from idle_balance()
Git-Commit-ID: 10a12983b3d437a6998b3845870e52c1c752c101
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10a12983b3d437a6998b3845870e52c1c752c101
Gitweb:     http://git.kernel.org/tip/10a12983b3d437a6998b3845870e52c1c752c101
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Wed, 1 Oct 2014 01:04:44 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 05:46:56 +0200

sched/fair: Delete resched_cpu() from idle_balance()

We already reschedule env.dst_cpu in attach_tasks()->check_preempt_curr()
if this is necessary.

Furthermore, a higher priority class task may be current on dest rq,
we shouldn't disturb it.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Cc: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140930210441.5258.55054.stgit@localhost
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dfdcbfd..bd61cff 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6701,12 +6701,6 @@ more_balance:
 
 		local_irq_restore(flags);
 
-		/*
-		 * some other cpu did the load balance for us.
-		 */
-		if (cur_ld_moved && env.dst_cpu != smp_processor_id())
-			resched_cpu(env.dst_cpu);
-
 		if (env.flags & LBF_NEED_BREAK) {
 			env.flags &= ~LBF_NEED_BREAK;
 			goto more_balance;
