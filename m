Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3ILSF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:05:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab3ILSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:05:53 -0400
Date: Thu, 12 Sep 2013 11:05:16 -0700
From: tip-bot for Li Bin <tipbot@zytor.com>
Message-ID: <tip-3b524d60943a2f9ee1194323ff9d5ee01a4d1ce1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        huawei.libin@huawei.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1378706740-7500-1-git-send-email-huawei.libin@huawei.com>
References: <1378706740-7500-1-git-send-email-huawei.libin@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/Documentation:
  Update sched-design-CFS.txt documentation
Git-Commit-ID: 3b524d60943a2f9ee1194323ff9d5ee01a4d1ce1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:05:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b524d60943a2f9ee1194323ff9d5ee01a4d1ce1
Gitweb:     http://git.kernel.org/tip/3b524d60943a2f9ee1194323ff9d5ee01a4d1ce1
Author:     Li Bin <huawei.libin@huawei.com>
AuthorDate: Mon, 9 Sep 2013 14:05:40 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:14:17 +0200

sched/Documentation: Update sched-design-CFS.txt documentation

2bd2d6f2dc ("sched: Replace use of entity_key()") had remove the
entity_key() which function is to subtract a tasks vruntime by
its groups minvruntime as the rbtree key.
The phrase "there is a subtraction using rq->cfs.min_vruntime
to account for possible wraparounds" in documentation feels strange
and meaningless. So remove it.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378706740-7500-1-git-send-email-huawei.libin@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/scheduler/sched-design-CFS.txt | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index d529e02d..f14f493 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -66,9 +66,7 @@ rq->cfs.load value, which is the sum of the weights of the tasks queued on the
 runqueue.
 
 CFS maintains a time-ordered rbtree, where all runnable tasks are sorted by the
-p->se.vruntime key (there is a subtraction using rq->cfs.min_vruntime to
-account for possible wraparounds).  CFS picks the "leftmost" task from this
-tree and sticks to it.
+p->se.vruntime key. CFS picks the "leftmost" task from this tree and sticks to it.
 As the system progresses forwards, the executed tasks are put into the tree
 more and more to the right --- slowly but surely giving a chance for every task
 to become the "leftmost task" and thus get on the CPU within a deterministic
