Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaJ1LIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:08:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaJ1LId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:08:33 -0400
Date: Tue, 28 Oct 2014 04:07:38 -0700
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-1d7e974cbf2fce2683f34ff33c173fd7ef5478c7@git.kernel.org>
Cc: peterz@infradead.org, mingo@kernel.org, hpa@zytor.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, wanpeng.li@linux.intel.com
Reply-To: peterz@infradead.org, mingo@kernel.org, hpa@zytor.com,
        torvalds@linux-foundation.org, wanpeng.li@linux.intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Don't check SD_BALANCE_FORK
Git-Commit-ID: 1d7e974cbf2fce2683f34ff33c173fd7ef5478c7
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

Commit-ID:  1d7e974cbf2fce2683f34ff33c173fd7ef5478c7
Gitweb:     http://git.kernel.org/tip/1d7e974cbf2fce2683f34ff33c173fd7ef5478c7
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Tue, 14 Oct 2014 10:22:39 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:48:01 +0100

sched/deadline: Don't check SD_BALANCE_FORK

There is no need to do balance during fork since SCHED_DEADLINE
tasks can't fork. This patch avoid the SD_BALANCE_FORK check.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 8aaa971..fab3bf8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -933,7 +933,7 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
 	struct task_struct *curr;
 	struct rq *rq;
 
-	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
+	if (sd_flag != SD_BALANCE_WAKE)
 		goto out;
 
 	rq = cpu_rq(cpu);
