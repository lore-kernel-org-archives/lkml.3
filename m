Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaIUTgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 15:36:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaIUTge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:36:34 -0400
Date: Sun, 21 Sep 2014 21:33:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] sched: fix the task-group check in tg_has_rt_tasks()
Message-ID: <20140921193336.GA28618@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140921193316.GA28596@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tg_has_rt_tasks() wants to find an RT task in this task_group, but
task_rq(p)->rt.tg wrongly checks the root rt_rq.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index eee12b3..9023f56 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7354,7 +7354,7 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
 	struct task_struct *g, *p;
 
 	for_each_process_thread(g, p) {
-		if (rt_task(p) && task_rq(p)->rt.tg == tg)
+		if (rt_task(p) && task_group(p) == tg)
 			return 1;
 	}
 
-- 
1.5.5.1

