Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaHMTWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:22:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbaHMTW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:22:27 -0400
Date: Wed, 13 Aug 2014 21:20:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] sched: change autogroup_move_group() to use
	for_each_thread()
Message-ID: <20140813192003.GA19334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813191938.GA19301@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change autogroup_move_group() to use for_each_thread() instead of
buggy while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/auto_group.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index e73efba..8a2e230 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -148,11 +148,8 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
 		goto out;
 
-	t = p;
-	do {
+	for_each_thread(p, t)
 		sched_move_task(t);
-	} while_each_thread(p, t);
-
 out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
-- 
1.5.5.1

