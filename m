Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaB0Mel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:34:41 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52532 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaB0Mej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:34:39 -0500
Date: Thu, 27 Feb 2014 18:04:31 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        josh@joshtriplett.org
Subject: [PATCH 44/46] kernel: Move prototype declaration to header file
 kernel/sched/sched.h from kernel/sched/rt.c
Message-ID: <98fe174e8dc10b3d28851909fa791acada23fbcd.1393493278.git.rashika.kheria@gmail.com>
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

Move prototype declaration of function to header file
kernel/sched/sched.h from kernel/sched/rt.c because it is used by more
than one file.

This eliminates the following warning in kernel/sched/debug.c:
kernel/sched/debug.c:246:6: warning: no previous prototype for ‘print_rt_rq’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/rt.c    |    1 -
 kernel/sched/sched.h |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a2740b7..2fe28c8 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2015,7 +2015,6 @@ const struct sched_class rt_sched_class = {
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-extern void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
 
 void print_rt_stats(struct seq_file *m, int cpu)
 {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c3688e2..608dd7b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1485,6 +1485,7 @@ extern struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq);
 extern struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq);
 extern void print_cfs_stats(struct seq_file *m, int cpu);
 extern void print_rt_stats(struct seq_file *m, int cpu);
+void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
-- 
1.7.9.5

