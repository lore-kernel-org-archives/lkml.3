Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaBVSEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:04:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaBVSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:04:33 -0500
Date: Sat, 22 Feb 2014 10:03:46 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-d277d868dab6537a85f4757e39648b1d6afc60d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        josh@joshtriplett.org, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        josh@joshtriplett.org, yangds.fnst@cn.fujitsu.com
In-Reply-To: <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] rcu: Use MAX_NICE to replace hardcoding of 19
Git-Commit-ID: d277d868dab6537a85f4757e39648b1d6afc60d5
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

Commit-ID:  d277d868dab6537a85f4757e39648b1d6afc60d5
Gitweb:     http://git.kernel.org/tip/d277d868dab6537a85f4757e39648b1d6afc60d5
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:49 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 22 Feb 2014 18:15:24 +0100

rcu: Use MAX_NICE to replace hardcoding of 19

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/rcu/torture.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
index 732f8ae..219761d 100644
--- a/kernel/rcu/torture.c
+++ b/kernel/rcu/torture.c
@@ -805,7 +805,7 @@ rcu_torture_writer(void *arg)
 	static DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 
 	do {
 		schedule_timeout_uninterruptible(1);
@@ -871,7 +871,7 @@ rcu_torture_fakewriter(void *arg)
 	DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 
 	do {
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
@@ -987,7 +987,7 @@ rcu_torture_reader(void *arg)
 	unsigned long long ts;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 	if (irqreader && cur_ops->irq_capable)
 		setup_timer_on_stack(&t, rcu_torture_timer, 0);
 
@@ -1584,7 +1584,7 @@ static int rcu_torture_barrier_cbs(void *arg)
 
 	init_rcu_head_on_stack(&rcu);
 	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 	do {
 		wait_event(barrier_cbs_wq[myid],
 			   (newphase =
