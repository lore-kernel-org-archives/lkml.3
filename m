Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaHMTWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:22:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaHMTWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:22:23 -0400
Date: Wed, 13 Aug 2014 21:19:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] sched: s/do_each_thread/for_each_process_thread/ in
	debug.c
Message-ID: <20140813191956.GA19324@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813191938.GA19301@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change kernel/sched/debug.c to use for_each_process_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/debug.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 627b3c3..c7fe1ea 100644
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
 
-- 
1.5.5.1

