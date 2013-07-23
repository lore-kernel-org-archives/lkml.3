Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3GWHrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:47:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3GWHrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:47:04 -0400
Date: Tue, 23 Jul 2013 00:46:10 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-87e3c8ae1c8676b9dd56b56456dafa14a4bacf97@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
In-Reply-To: <169201374366727@web6d.yandex.ru>
References: <169201374366727@web6d.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Cleanup:
  remove duplicate variable declaration
Git-Commit-ID: 87e3c8ae1c8676b9dd56b56456dafa14a4bacf97
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:46:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87e3c8ae1c8676b9dd56b56456dafa14a4bacf97
Gitweb:     http://git.kernel.org/tip/87e3c8ae1c8676b9dd56b56456dafa14a4bacf97
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Sun, 21 Jul 2013 04:32:07 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 22 Jul 2013 10:27:40 +0200

sched/fair: Cleanup: remove duplicate variable declaration

cfs_rq is declared twice, fix it.

Also use 'se' instead of '&p->se'.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/169201374366727@web6d.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bb456f4..ab59978 100644
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
