Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaIXH70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:59:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55538 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaIXH7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:59:23 -0400
Date: Wed, 24 Sep 2014 00:57:53 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-be34f0f3e6aed6e828a8059247d169d38da128d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        mgorman@suse.de, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20140921194743.GA30114@redhat.com>
References: <20140921194743.GA30114@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Kill the wrong/
 dead TASK_DEAD check in task_numa_fault()
Git-Commit-ID: be34f0f3e6aed6e828a8059247d169d38da128d7
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

Commit-ID:  be34f0f3e6aed6e828a8059247d169d38da128d7
Gitweb:     http://git.kernel.org/tip/be34f0f3e6aed6e828a8059247d169d38da128d7
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 21 Sep 2014 21:47:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 09:35:05 +0200

sched/numa: Kill the wrong/dead TASK_DEAD check in task_numa_fault()

current->state == TASK_DEAD means that the task is doing its
last schedule(), page fault is obviously impossible at this
stage.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140921194743.GA30114@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a1e6ac..9ee3d4f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1817,10 +1817,6 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (!p->mm)
 		return;
 
-	/* Do not worry about placement if exiting */
-	if (p->state == TASK_DEAD)
-		return;
-
 	/* Allocate buffer to track faults on a per-node basis */
 	if (unlikely(!p->numa_faults_memory)) {
 		int size = sizeof(*p->numa_faults_memory) *
