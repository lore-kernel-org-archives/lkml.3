Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936914Ab3DJJZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:25:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3DJJZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:25:37 -0400
Date: Wed, 10 Apr 2013 02:25:16 -0700
From: tip-bot for Stanislaw Gruszka <tipbot@zytor.com>
Message-ID: <tip-e614b3332a4f3f264a26da28e5a1f4cc3aea3974@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
        oleg@redhat.com, sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
        oleg@redhat.com, sgruszka@redhat.com
In-Reply-To: <20130404085740.GA2495@redhat.com>
References: <20130404085740.GA2495@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/cputime:
  Fix accounting on multi-threaded processes
Git-Commit-ID: e614b3332a4f3f264a26da28e5a1f4cc3aea3974
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 02:25:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e614b3332a4f3f264a26da28e5a1f4cc3aea3974
Gitweb:     http://git.kernel.org/tip/e614b3332a4f3f264a26da28e5a1f4cc3aea3974
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Thu, 4 Apr 2013 10:57:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 17:40:52 +0200

sched/cputime: Fix accounting on multi-threaded processes

Recent commit 6fac4829 ("cputime: Use accessors to read task
cputime stats") introduced a bug, where we account many times
the cputime of the first thread, instead of cputimes of all
the different threads.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130404085740.GA2495@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cputime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
