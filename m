Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaEMX4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:56:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaEMX4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:56:52 -0400
Date: Tue, 13 May 2014 19:55:50 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, mgorman@suse.de
Subject: [PATCH] sched,numa: move processes with load difference
Message-ID: <20140513195550.315a92bf@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the numa balancing code refuses to move a task from a
heavily loaded node to a much less heavily loaded node, if the
difference in load between them is large enough.

If the source load is larger than the destination load after the
swap, moving the task is fine. Chances are the load balancer would
move tasks in the same direction, anyway.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6d9474c..98a018f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1224,10 +1224,6 @@ static void task_numa_compare(struct task_numa_env *env,
 		src_load += load;
 	}
 
-	/* make src_load the smaller */
-	if (dst_load < src_load)
-		swap(dst_load, src_load);
-
 	if (src_load * env->imbalance_pct < dst_load * 100)
 		goto unlock;
 

