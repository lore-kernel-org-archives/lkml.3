Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaB0Lyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:54:55 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36870 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaB0Lyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:54:50 -0500
Date: Thu, 27 Feb 2014 17:24:41 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        josh@joshtriplett.org
Subject: [PATCH 21/46] kernel: Mark function as static in sched/deadline.c
Message-ID: <828a5d77a0d7579371bd3458831f095b6fe61045.1393493277.git.rashika.kheria@gmail.com>
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

Mark function as static in kernel/sched/deadline.c because it is not
used outside this file.

This eliminates the following warning in kernel/sched/deadline.c:
kernel/sched/deadline.c:993:21: warning: no previous prototype for ‘pick_next_task_dl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/deadline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0dd5e09..cd0f58a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -990,7 +990,7 @@ static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
 	return rb_entry(left, struct sched_dl_entity, rb_node);
 }
 
-struct task_struct *pick_next_task_dl(struct rq *rq)
+static struct task_struct *pick_next_task_dl(struct rq *rq)
 {
 	struct sched_dl_entity *dl_se;
 	struct task_struct *p;
-- 
1.7.9.5

