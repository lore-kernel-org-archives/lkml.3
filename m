Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935704Ab3BTOCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:02:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935114Ab3BTOCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:02:02 -0500
Date: Wed, 20 Feb 2013 06:00:32 -0800
From: tip-bot for Sha Zhengju <tipbot@zytor.com>
Message-ID: <tip-1c3e826482ab698e418c7a894440e62c76aac893@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, handai.szj@taobao.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, handai.szj@taobao.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1361351678-8065-1-git-send-email-handai.szj@taobao.com>
References: <1361351678-8065-1-git-send-email-handai.szj@taobao.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/core:
  Remove the obsolete and unused nr_uninterruptible() function
Git-Commit-ID: 1c3e826482ab698e418c7a894440e62c76aac893
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 20 Feb 2013 06:00:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c3e826482ab698e418c7a894440e62c76aac893
Gitweb:     http://git.kernel.org/tip/1c3e826482ab698e418c7a894440e62c76aac893
Author:     Sha Zhengju <handai.szj@taobao.com>
AuthorDate: Wed, 20 Feb 2013 17:14:38 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Feb 2013 11:39:24 +0100

sched/core: Remove the obsolete and unused nr_uninterruptible() function

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1361351678-8065-1-git-send-email-handai.szj@taobao.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  1 -
 kernel/sched/core.c   | 22 ++--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 33cc421..f9ca237d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -98,7 +98,6 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
-extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 03d7784..b7b03cd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1969,11 +1969,10 @@ context_switch(struct rq *rq, struct task_struct *prev,
 }
 
 /*
- * nr_running, nr_uninterruptible and nr_context_switches:
+ * nr_running and nr_context_switches:
  *
  * externally visible scheduler statistics: current number of runnable
- * threads, current number of uninterruptible-sleeping threads, total
- * number of context switches performed since bootup.
+ * threads, total number of context switches performed since bootup.
  */
 unsigned long nr_running(void)
 {
@@ -1985,23 +1984,6 @@ unsigned long nr_running(void)
 	return sum;
 }
 
-unsigned long nr_uninterruptible(void)
-{
-	unsigned long i, sum = 0;
-
-	for_each_possible_cpu(i)
-		sum += cpu_rq(i)->nr_uninterruptible;
-
-	/*
-	 * Since we read the counters lockless, it might be slightly
-	 * inaccurate. Do not allow it to go below zero though:
-	 */
-	if (unlikely((long)sum < 0))
-		sum = 0;
-
-	return sum;
-}
-
 unsigned long long nr_context_switches(void)
 {
 	int i;
