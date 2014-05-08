Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaEHKsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:48:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33488 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaEHKst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:48:49 -0400
Date: Thu, 8 May 2014 03:47:54 -0700
From: "tip-bot for Rafael J. Wysocki" <tipbot@zytor.com>
Message-ID: <tip-08c373e5123b4595588ae1a7aa7e00a046c61cc6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, tglx@linutronix.de,
        daniel.lezcano@linaro.org
In-Reply-To: <4717784.WmVEpDoliM@vostro.rjw.lan>
References: <4717784.WmVEpDoliM@vostro.rjw.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle: Make cpuidle_idle_call() void
Git-Commit-ID: 08c373e5123b4595588ae1a7aa7e00a046c61cc6
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

Commit-ID:  08c373e5123b4595588ae1a7aa7e00a046c61cc6
Gitweb:     http://git.kernel.org/tip/08c373e5123b4595588ae1a7aa7e00a046c61cc6
Author:     Rafael J. Wysocki <rafael.j.wysocki@intel.com>
AuthorDate: Mon, 21 Apr 2014 01:26:58 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 8 May 2014 09:17:00 +0200

sched/idle: Make cpuidle_idle_call() void

The only value ever returned by cpuidle_idle_call() is 0 and its
only caller ignores that value anyway, so make it void.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/4717784.WmVEpDoliM@vostro.rjw.lan
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/idle.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 88a6bc4..34083c9 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
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
@@ -82,7 +81,7 @@ static int cpuidle_idle_call(void)
 	 */
 	if (need_resched()) {
 		local_irq_enable();
-		return 0;
+		return;
 	}
 
 	/*
@@ -177,8 +176,6 @@ exit_idle:
 
 	rcu_idle_exit();
 	start_critical_timings();
-
-	return 0;
 }
 
 /*
