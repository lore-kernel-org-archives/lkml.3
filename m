Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab3BKVkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:40:10 -0500
Received: from forward3.mail.yandex.net ([77.88.46.8]:60652 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394Ab3BKVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:40:07 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH]sched/stop_task: Do not account zero delta_exec in put_prev_task_stop
MIME-Version: 1.0
Message-Id: <180751360618804@web6d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 12 Feb 2013 01:40:04 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple return

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
---
 kernel/sched/stop_task.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index da5eb5b..78d0458 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -58,8 +58,8 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	u64 delta_exec;
 
 	delta_exec = rq->clock_task - curr->se.exec_start;
-	if (unlikely((s64)delta_exec < 0))
-		delta_exec = 0;
+	if (unlikely((s64)delta_exec <= 0))
+		return;
 
 	schedstat_set(curr->se.statistics.exec_max,
 			max(curr->se.statistics.exec_max, delta_exec));
