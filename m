Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3DDI5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:57:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933804Ab3DDI5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:57:02 -0400
Date: Thu, 4 Apr 2013 10:57:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3.9 repost] cputime: Fix accounting on multi-threaded
 processes
Message-ID: <20130404085740.GA2495@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent commit 6fac4829 "cputime: Use accessors to read task cputime
stats" introduced a bug, that make we account many times cputime of
the first thread, instead of cputimes of all threads.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
This patch fixes 3.8 -> 3.9 regression, please apply.

 kernel/sched/cputime.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ed12cbb..e93cca9 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -310,7 +310,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 
 	t = tsk;
 	do {
-		task_cputime(tsk, &utime, &stime);
+		task_cputime(t, &utime, &stime);
 		times->utime += utime;
 		times->stime += stime;
 		times->sum_exec_runtime += task_sched_runtime(t);
-- 
1.7.1

