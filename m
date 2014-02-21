Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaBUVcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:32:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59303 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbaBUVcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:32:11 -0500
Date: Fri, 21 Feb 2014 13:31:39 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a2885f6bf67671c83f9162a271bc8898d5062842@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        bigeasy@linutronix.de
In-Reply-To: <1391803122-4425-3-git-send-email-bigeasy@linutronix.de>
References: <1391803122-4425-3-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Check for idle task in might_sleep()
Git-Commit-ID: a2885f6bf67671c83f9162a271bc8898d5062842
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

Commit-ID:  a2885f6bf67671c83f9162a271bc8898d5062842
Gitweb:     http://git.kernel.org/tip/a2885f6bf67671c83f9162a271bc8898d5062842
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 7 Feb 2014 20:58:38 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:18 +0100

sched: Check for idle task in might_sleep()

Idle is not allowed to call sleeping functions ever!

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1391803122-4425-3-git-send-email-bigeasy@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 86e0558..37d35e8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6935,7 +6935,8 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
-	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
+	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
+	     !is_idle_task(current)) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
