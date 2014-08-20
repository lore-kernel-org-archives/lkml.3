Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaHTIU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:20:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46984 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaHTIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:20:55 -0400
Date: Wed, 20 Aug 2014 01:19:08 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-d38e83c715270cc2e137bbf6f25206c8c023896b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, seto.hidetoshi@jp.fujitsu.com,
        peterz@infradead.org, umgwanakikbuti@gmail.com, riel@redhat.com,
        fmayhar@google.com, akpm@linux-foundation.org, srao@redhat.com,
        fweisbec@redhat.com, tglx@linutronix.de, oleg@redhat.com,
        lwoodman@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, torvalds@linux-foundation.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com, riel@redhat.com,
        fmayhar@google.com, akpm@linux-foundation.org, fweisbec@redhat.com,
        srao@redhat.com, oleg@redhat.com, tglx@linutronix.de,
        lwoodman@redhat.com
In-Reply-To: <20140813191956.GA19324@redhat.com>
References: <20140813191956.GA19324@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: s/do_each_thread/for_each_process_thread/
  in debug.c
Git-Commit-ID: d38e83c715270cc2e137bbf6f25206c8c023896b
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

Commit-ID:  d38e83c715270cc2e137bbf6f25206c8c023896b
Gitweb:     http://git.kernel.org/tip/d38e83c715270cc2e137bbf6f25206c8c023896b
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 13 Aug 2014 21:19:56 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Aug 2014 09:47:17 +0200

sched: s/do_each_thread/for_each_process_thread/ in debug.c

Change kernel/sched/debug.c to use for_each_process_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Frank Mayhar <fmayhar@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sanjay Rao <srao@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140813191956.GA19324@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 627b3c3..c7fe1ea0 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -160,14 +160,12 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	"----------------------------------------------------\n");
 
 	read_lock_irqsave(&tasklist_lock, flags);
-
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		if (task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
-	} while_each_thread(g, p);
-
+	}
 	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
