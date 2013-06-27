Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3F0JCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:02:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3F0JCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:42 -0400
Date: Thu, 27 Jun 2013 02:02:06 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-83dfd5235ebd66c284b97befe6eabff7132333e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, alex.shi@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, tglx@linutronix.de,
        alex.shi@intel.com
In-Reply-To: <1371694737-29336-6-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-6-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Update cpu load after task_tick
Git-Commit-ID: 83dfd5235ebd66c284b97befe6eabff7132333e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:02:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83dfd5235ebd66c284b97befe6eabff7132333e6
Gitweb:     http://git.kernel.org/tip/83dfd5235ebd66c284b97befe6eabff7132333e6
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:49 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:33 +0200

sched: Update cpu load after task_tick

To get the latest runnable info, we need do this cpuload update after
task_tick.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-6-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 729e7fc..08746cc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2165,8 +2165,8 @@ void scheduler_tick(void)
 
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
-	update_cpu_load_active(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
+	update_cpu_load_active(rq);
 	raw_spin_unlock(&rq->lock);
 
 	perf_event_task_tick();
