Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbaFXEbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 00:31:10 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:59857 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaFXEbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 00:31:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] sched/idle: Drop !! while calculating 'broadcast'
Date: Tue, 24 Jun 2014 10:01:01 +0530
Message-Id: <0dfbe2976aa108c53e08d3477ea90f6360c1f54c.1403584026.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need 'broadcast' to be set to 'zero or one', but to 'zero or non-zero'
and so the extra operation to convert it to 'zero or one' can be skipped.

Also change type of 'broadcast' to unsigned int, i.e. type of
drv->states[*].flags.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Rebased over: 3.16-rc2.

 kernel/sched/idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index cf009fb..9f1608f 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -79,7 +79,7 @@ static void cpuidle_idle_call(void)
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state;
-	bool broadcast;
+	unsigned int broadcast;
 
 	/*
 	 * Check if the idle task must be rescheduled. If it is the
@@ -135,7 +135,7 @@ use_default:
 		goto exit_idle;
 	}
 
-	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
+	broadcast = drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP;
 
 	/*
 	 * Tell the time framework to switch to a broadcast timer
-- 
2.0.0.rc2

