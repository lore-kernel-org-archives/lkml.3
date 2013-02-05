Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3BELiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:38:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32418 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3BELiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:38:11 -0500
Date: Tue, 5 Feb 2013 14:37:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, kbuild@01.org
Subject: [patch] sched: signedness bug in yield_to()
Message-ID: <20130205113751.GA20521@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 7b270f6099 "sched: Bail out of yield_to when source and target
runqueue has one task" we changed this to store -ESRCH so it needs to
be signed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3e7b280..7ba7ea5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4384,7 +4384,7 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
 	struct task_struct *curr = current;
 	struct rq *rq, *p_rq;
 	unsigned long flags;
-	bool yielded = 0;
+	int yielded = 0;
 
 	local_irq_save(flags);
 	rq = this_rq();
