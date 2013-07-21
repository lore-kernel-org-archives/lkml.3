Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3GUAcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 20:32:18 -0400
Received: from forward2.mail.yandex.net ([77.88.46.7]:59881 "EHLO
	forward2.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab3GUAcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 20:32:17 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH]sched/fair: Cleanup: remove dublicate variable declaration
MIME-Version: 1.0
Message-Id: <169201374366727@web6d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sun, 21 Jul 2013 04:32:07 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfs_rq is declarated twice. place_entity() doesn't change cfs_rq,
so it's erratum. Fix that.
(and use above declarated se instead of &p->se)

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/fair.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9565645..f918635 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5889,11 +5889,9 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	* and ensure we don't carry in an old decay_count if we
 	* switch back.
 	*/
-	if (p->se.avg.decay_count) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
-		__synchronize_entity_decay(&p->se);
-		subtract_blocked_load_contrib(cfs_rq,
-				p->se.avg.load_avg_contrib);
+	if (se->avg.decay_count) {
+		__synchronize_entity_decay(se);
+		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
 	}
 #endif
 }
