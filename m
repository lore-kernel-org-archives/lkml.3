Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3BEPYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:24:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3BEPYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:24:16 -0500
Date: Tue, 5 Feb 2013 07:23:50 -0800
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-c3c186403c6abd32e719f005f0af950155a9e54d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        efault@gmx.de, peterz@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, efault@gmx.de,
        tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20130205113751.GA20521@elgon.mountain>
References: <20130205113751.GA20521@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix signedness bug in yield_to()
Git-Commit-ID: c3c186403c6abd32e719f005f0af950155a9e54d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 05 Feb 2013 07:23:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3c186403c6abd32e719f005f0af950155a9e54d
Gitweb:     http://git.kernel.org/tip/c3c186403c6abd32e719f005f0af950155a9e54d
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Tue, 5 Feb 2013 14:37:51 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 5 Feb 2013 12:59:29 +0100

sched: Fix signedness bug in yield_to()

In 7b270f6099 "sched: Bail out of yield_to when source and
target runqueue has one task" we changed this to store -ESRCH so
it needs to be signed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: kbuild@01.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Link: http://lkml.kernel.org/r/20130205113751.GA20521@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..c5b089d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4371,7 +4371,7 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
 	struct task_struct *curr = current;
 	struct rq *rq, *p_rq;
 	unsigned long flags;
-	bool yielded = 0;
+	int yielded = 0;
 
 	local_irq_save(flags);
 	rq = this_rq();
