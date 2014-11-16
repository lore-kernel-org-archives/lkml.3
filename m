Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaKPMee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:34:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35585 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbaKPMea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:34:30 -0500
Date: Sun, 16 Nov 2014 04:33:51 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-36ce98818a4df66c8134c31fd6e768b4119c7a90@git.kernel.org>
Cc: wanpeng.li@linux.intel.com, juri.lelli@arm.com, tglx@linutronix.de,
        peterz@infradead.org, torvalds@linux-foundation.org,
        ktkhai@parallels.com, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: wanpeng.li@linux.intel.com, juri.lelli@arm.com, ktkhai@parallels.com,
        torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org
In-Reply-To: <1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Introduce start_hrtick_dl()
  for !CONFIG_SCHED_HRTICK
Git-Commit-ID: 36ce98818a4df66c8134c31fd6e768b4119c7a90
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

Commit-ID:  36ce98818a4df66c8134c31fd6e768b4119c7a90
Gitweb:     http://git.kernel.org/tip/36ce98818a4df66c8134c31fd6e768b4119c7a90
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Tue, 11 Nov 2014 09:52:26 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:59:03 +0100

sched/deadline: Introduce start_hrtick_dl() for !CONFIG_SCHED_HRTICK

Introduce start_hrtick_dl for !CONFIG_SCHED_HRTICK to align with
the fair class.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9594c12..e5db8c6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1013,6 +1013,10 @@ static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
 {
 	hrtick_start(rq, p->dl.runtime);
 }
+#else /* !CONFIG_SCHED_HRTICK */
+static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
+{
+}
 #endif
 
 static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
@@ -1066,10 +1070,8 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 	/* Running task will never be pushed. */
        dequeue_pushable_dl_task(rq, p);
 
-#ifdef CONFIG_SCHED_HRTICK
 	if (hrtick_enabled(rq))
 		start_hrtick_dl(rq, p);
-#endif
 
 	set_post_schedule(rq);
 
@@ -1088,10 +1090,8 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
 {
 	update_curr_dl(rq);
 
-#ifdef CONFIG_SCHED_HRTICK
 	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
 		start_hrtick_dl(rq, p);
-#endif
 }
 
 static void task_fork_dl(struct task_struct *p)
