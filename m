Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaBRWM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:12:58 -0500
Received: from shelob.surriel.com ([74.92.59.67]:50178 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaBRWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:12:57 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        chegu_vinod@hp.com, aarcange@redhat.com, akpm@linux-foundation.org
Subject: [PATCH -mm 1/3] sched,numa: add cond_resched to task_numa_work
Date: Tue, 18 Feb 2014 17:12:44 -0500
Message-Id: <1392761566-24834-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392761566-24834-1-git-send-email-riel@redhat.com>
References: <1392761566-24834-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Normally task_numa_work scans over a fairly small amount of memory,
but it is possible to run into a large unpopulated part of virtual
memory, with no pages mapped. In that case, task_numa_work can run
for a while, and it may make sense to reschedule as required.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Xing Gang <gang.xing@hp.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 kernel/sched/fair.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 966cc2b..7815709 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1757,6 +1757,8 @@ void task_numa_work(struct callback_head *work)
 			start = end;
 			if (pages <= 0)
 				goto out;
+
+			cond_resched();
 		} while (end != vma->vm_end);
 	}
 
-- 
1.8.5.3

