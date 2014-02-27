Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaB0Lxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:53:43 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40278 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaB0Lxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:53:42 -0500
Date: Thu, 27 Feb 2014 17:23:33 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        josh@joshtriplett.org
Subject: [PATCH 20/46] kernel: Move prototype declaration to header file
 sched/sched.h from sched/core.c
Message-ID: <f5593826852477fbb4d7d153f5e5809501efb385.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype definition of function to header file
kernel/sched/sched.h from kernel/sched/core.c because it is used by more
than one file.

This eliminates the following warning in kernel/sched/deadline.c:62:6:
kernel/sched/deadline.c:62:6: warning: no previous prototype for ‘init_dl_bw’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/core.c  |    2 --
 kernel/sched/sched.h |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..90570e1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1985,8 +1985,6 @@ static int dl_overflow(struct task_struct *p, int policy,
 	return err;
 }
 
-extern void init_dl_bw(struct dl_bw *dl_b);
-
 /*
  * wake_up_new_task - wake up a newly created task for the first time.
  *
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c2119fd..586613e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1204,6 +1204,7 @@ extern void resched_cpu(int cpu);
 extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
 
+void init_dl_bw(struct dl_bw *dl_b);
 extern struct dl_bandwidth def_dl_bandwidth;
 extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime);
 extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
-- 
1.7.9.5

