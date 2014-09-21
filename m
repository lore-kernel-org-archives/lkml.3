Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaIUTus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 15:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaIUTur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:50:47 -0400
Date: Sun, 21 Sep 2014 21:47:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sched/numa: kill the wrong/dead TASK_DEAD check in
	task_numa_fault()
Message-ID: <20140921194743.GA30114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current->state == TASK_DEAD means that the task is doing its last
schedule(), page fault is obviously impossible at this stage.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/fair.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 82088b2..0090e8c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1804,10 +1804,6 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (!p->mm)
 		return;
 
-	/* Do not worry about placement if exiting */
-	if (p->state == TASK_DEAD)
-		return;
-
 	/* Allocate buffer to track faults on a per-node basis */
 	if (unlikely(!p->numa_faults_memory)) {
 		int size = sizeof(*p->numa_faults_memory) *
-- 
1.5.5.1


