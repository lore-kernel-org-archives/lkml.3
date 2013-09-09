Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3IIGIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:08:18 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:38428 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3IIGIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:08:17 -0400
From: Libin <huawei.libin@huawei.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <rob@landley.net>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangyijing@huawei.com>, <guohanjun@huawei.com>, <xiexiuqi@huawei.com>,
        <huawei.libin@huawei.com>
Subject: [PATCH] Documentation/sched: update sched-design-CFS.txt documentation
Date: Mon, 9 Sep 2013 14:05:40 +0800
Message-ID: <1378706740-7500-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

2bd2d6f2dc ("sched: Replace use of entity_key()") had remove the
entity_key() which function is to subtract a tasks vruntime by
its groups minvruntime as the rbtree key.
The phrase "there is a subtraction using rq->cfs.min_vruntime
to account for possible wraparounds" in documentation feels strange
and meaningless. So remove it.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
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
-- 
1.8.2.1


