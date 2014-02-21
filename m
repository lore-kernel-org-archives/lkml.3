Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbaBUVeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:34:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59413 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbaBUVeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:34:20 -0500
Date: Fri, 21 Feb 2014 13:33:41 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-c30f4ba1cb3f89cefba728f5289caf3c0fc7149d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        josh@joshtriplett.org, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        josh@joshtriplett.org, yangds.fnst@cn.fujitsu.com
In-Reply-To: <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] rcu: Use MAX_NICE to replace hard coding of 19.
Git-Commit-ID: c30f4ba1cb3f89cefba728f5289caf3c0fc7149d
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

Commit-ID:  c30f4ba1cb3f89cefba728f5289caf3c0fc7149d
Gitweb:     http://git.kernel.org/tip/c30f4ba1cb3f89cefba728f5289caf3c0fc7149d
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:49 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:20 +0100

rcu: Use MAX_NICE to replace hard coding of 19.

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
