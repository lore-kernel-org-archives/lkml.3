Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaBNUUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:20:01 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:48858 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbaBNUT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:56 -0500
Message-Id: <20140214201906.228793215@linux.com>
Date: Fri, 14 Feb 2014 14:19:03 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 22/48] tick-sched: Fix two new uses of __get_cpu_ptr
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=fix_sched
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two new uses introduced in 3.14-rc1.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c	2014-02-03 13:36:18.968910485 -0600
+++ linux/kernel/time/tick-sched.c	2014-02-03 13:36:18.968910485 -0600
@@ -909,7 +909,7 @@
  */
 void tick_nohz_idle_exit(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now;
 
 	local_irq_disable();
@@ -1026,7 +1026,7 @@
 
 static inline void tick_nohz_irq_enter(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now;
 
 	if (!ts->idle_active && !ts->tick_stopped)

