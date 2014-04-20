Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaDTXKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 19:10:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50933 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751046AbaDTXKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 19:10:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched / idle: Make cpuidle_idle_call() void
Date: Mon, 21 Apr 2014 01:26:58 +0200
Message-ID: <4717784.WmVEpDoliM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The only value ever returned by cpuidle_idle_call() is 0 and its
only caller ignores that value anyway, so make it void.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/sched/idle.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-pm/kernel/sched/idle.c
===================================================================
--- linux-pm.orig/kernel/sched/idle.c
+++ linux-pm/kernel/sched/idle.c
@@ -67,9 +67,8 @@ void __weak arch_cpu_idle(void)
  * cpuidle_idle_call - the main idle function
  *
  * NOTE: no locks or semaphores should be used here
- * return non-zero on failure
  */
-static int cpuidle_idle_call(void)
+static void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
@@ -84,7 +83,7 @@ static int cpuidle_idle_call(void)
 	if (current_clr_polling_and_test()) {
 		local_irq_enable();
 		__current_set_polling();
-		return 0;
+		return;
 	}
 
 	/*
@@ -189,8 +188,6 @@ static int cpuidle_idle_call(void)
 
 	rcu_idle_exit();
 	start_critical_timings();
-
-	return 0;
 }
 
 /*

