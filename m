Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbaBUVfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:35:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59462 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaBUVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:35:05 -0500
Date: Fri, 21 Feb 2014 13:34:26 -0800
From: tip-bot for Morten Rasmussen <tipbot@zytor.com>
Message-ID: <tip-183d5fc846e6653530567810397750f922d374cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, morten.rasmussen@arm.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1392732864-10927-1-git-send-email-morten.rasmussen@arm.com>
References: <1392732864-10927-1-git-send-email-morten.rasmussen@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix select_task_rq_fair()
  description comments
Git-Commit-ID: 183d5fc846e6653530567810397750f922d374cf
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

Commit-ID:  183d5fc846e6653530567810397750f922d374cf
Gitweb:     http://git.kernel.org/tip/183d5fc846e6653530567810397750f922d374cf
Author:     Morten Rasmussen <morten.rasmussen@arm.com>
AuthorDate: Tue, 18 Feb 2014 14:14:24 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:21 +0100

sched: Fix select_task_rq_fair() description comments

Brings select_task_rq_fair() description comments up-to-date.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392732864-10927-1-git-send-email-morten.rasmussen@arm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fb6f220..37ee473 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4397,13 +4397,14 @@ done:
 }
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
- * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
- * SD_BALANCE_EXEC.
+ * select_task_rq_fair: Select target runqueue for the waking task in domains
+ * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
+ * SD_BALANCE_FORK, or SD_BALANCE_EXEC.
  *
- * Balance, ie. select the least loaded group.
+ * Balances load by selecting the idlest cpu in the idlest group, or under
+ * certain conditions an idle sibling cpu if the domain has SD_WAKE_AFFINE set.
  *
- * Returns the target CPU number, or the same CPU if no balancing is needed.
+ * Returns the target cpu number.
  *
  * preempt must be disabled.
  */
