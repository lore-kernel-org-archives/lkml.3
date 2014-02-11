Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaBKHf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:35:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaBKHfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:35:09 -0500
X-IronPort-AV: E=Sophos;i="4.95,824,1384272000"; 
   d="scan'208";a="9505342"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Josh Triplett <josh@freedesktop.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5/9] rcu: Use MAX_NICE to replace hard coding of 19.
Date: Tue, 11 Feb 2014 15:34:49 +0800
Message-Id: <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:06,
	Serialize complete at 2014/02/11 15:33:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Josh Triplett <josh@freedesktop.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>
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
-- 
1.8.2.1

