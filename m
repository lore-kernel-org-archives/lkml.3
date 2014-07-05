Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122AbaGEKnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:43:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaGEKnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:43:49 -0400
Date: Sat, 5 Jul 2014 03:43:17 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-541b82644d72c1ef4a0587515a619712c1c19bd3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <afb781733e4a9ffbced5eb9fd25cc0aa5c6ffd7a.1403596966.git.viresh.kumar@linaro.org>
References: <afb781733e4a9ffbced5eb9fd25cc0aa5c6ffd7a.1403596966.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/core:
  Fix formatting issues in sched_can_stop_tick()
Git-Commit-ID: 541b82644d72c1ef4a0587515a619712c1c19bd3
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

Commit-ID:  541b82644d72c1ef4a0587515a619712c1c19bd3
Gitweb:     http://git.kernel.org/tip/541b82644d72c1ef4a0587515a619712c1c19bd3
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 24 Jun 2014 14:04:12 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:28 +0200

sched/core: Fix formatting issues in sched_can_stop_tick()

sched_can_stop_tick() is using 7 spaces instead of 8 spaces or a 'tab' at the
beginning of few lines. Which doesn't align well with the Coding Guidelines.

Also remove local variable 'rq' as it is used at only one place and we can
directly use this_rq() instead.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: fweisbec@gmail.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/afb781733e4a9ffbced5eb9fd25cc0aa5c6ffd7a.1403596966.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f3063c..866d840 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -736,19 +736,15 @@ static inline bool got_nohz_idle_kick(void)
 #ifdef CONFIG_NO_HZ_FULL
 bool sched_can_stop_tick(void)
 {
-       struct rq *rq;
-
-       rq = this_rq();
-
 	/*
 	 * More than one running task need preemption.
 	 * nr_running update is assumed to be visible
 	 * after IPI is sent from wakers.
 	 */
-       if (rq->nr_running > 1)
-               return false;
+	if (this_rq()->nr_running > 1)
+		return false;
 
-       return true;
+	return true;
 }
 #endif /* CONFIG_NO_HZ_FULL */
 
