Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666Ab3GZXou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:44:50 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34103 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760521Ab3GZXn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:43:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 17/21] vtime: Always scale generic vtime accounting results
Date: Sat, 27 Jul 2013 01:42:40 +0200
Message-Id: <1374882164-32519-18-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374882164-32519-1-git-send-email-fweisbec@gmail.com>
References: <1374882164-32519-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cputime accounting in full dynticks can be a subtle
mixup of CPUs using tick based accounting and others using
generic vtime.

As long as the tick can have a share on producing these stats, we
want to scale the result against CFS precise accounting as the tick
can miss some task hiding between the periodic interrupt.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
---
 kernel/sched/cputime.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 0831b06..e9e742e 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -553,12 +553,6 @@ static void cputime_adjust(struct task_cputime *curr,
 {
 	cputime_t rtime, stime, utime, total;
 
-	if (vtime_accounting_enabled()) {
-		*ut = curr->utime;
-		*st = curr->stime;
-		return;
-	}
-
 	stime = curr->stime;
 	total = stime + curr->utime;
 
-- 
1.7.5.4

