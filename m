Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965278AbaGEKou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:44:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965179AbaGEKos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:44:48 -0400
Date: Sat, 5 Jul 2014 03:43:58 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-89abb5ad10ae8ac3405e635ac80815f781c8b8e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <0dfbe2976aa108c53e08d3477ea90f6360c1f54c.1403584026.git.viresh.kumar@linaro.org>
References: <0dfbe2976aa108c53e08d3477ea90f6360c1f54c.1403584026.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle: Drop !! while calculating 'broadcast
 '
Git-Commit-ID: 89abb5ad10ae8ac3405e635ac80815f781c8b8e9
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

Commit-ID:  89abb5ad10ae8ac3405e635ac80815f781c8b8e9
Gitweb:     http://git.kernel.org/tip/89abb5ad10ae8ac3405e635ac80815f781c8b8e9
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 24 Jun 2014 10:01:01 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:31 +0200

sched/idle: Drop !! while calculating 'broadcast'

We don't need 'broadcast' to be set to 'zero or one', but to 'zero or non-zero'
and so the extra operation to convert it to 'zero or one' can be skipped.

Also change type of 'broadcast' to unsigned int, i.e. type of
drv->states[*].flags.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/0dfbe2976aa108c53e08d3477ea90f6360c1f54c.1403584026.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
