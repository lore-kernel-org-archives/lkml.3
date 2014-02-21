Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaBUUdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:33:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaBUUdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:33:02 -0500
Date: Fri, 21 Feb 2014 12:32:14 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-3cf1962cdbf6b3a9e3ef21116d215bbab350ea37@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, gang.xing@hp.com, riel@redhat.com,
        aarcange@redhat.com, chegu_vinod@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, gang.xing@hp.com, riel@redhat.com,
        aarcange@redhat.com, chegu_vinod@hp.com, tglx@linutronix.de
In-Reply-To: <1392761566-24834-2-git-send-email-riel@redhat.com>
References: <1392761566-24834-2-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched,numa: add cond_resched to task_numa_work
Git-Commit-ID: 3cf1962cdbf6b3a9e3ef21116d215bbab350ea37
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

Commit-ID:  3cf1962cdbf6b3a9e3ef21116d215bbab350ea37
Gitweb:     http://git.kernel.org/tip/3cf1962cdbf6b3a9e3ef21116d215bbab350ea37
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Tue, 18 Feb 2014 17:12:44 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:27:10 +0100

sched,numa: add cond_resched to task_numa_work

Normally task_numa_work scans over a fairly small amount of memory,
but it is possible to run into a large unpopulated part of virtual
memory, with no pages mapped. In that case, task_numa_work can run
for a while, and it may make sense to reschedule as required.

Cc: akpm@linux-foundation.org
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Xing Gang <gang.xing@hp.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392761566-24834-2-git-send-email-riel@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
