Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbaJaLVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:21:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900AbaJaLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:21:44 -0400
Message-Id: <20141031111549.857381983@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 31 Oct 2014 12:10:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: peter@hurleysoftware.com, oleg@redhat.com, rjw@rjwysocki.net,
        torvalds@linux-foundation.org, tglx@linutronix.de, eparis@redhat.com,
        umgwanakikbuti@gmail.com, marcel@holtmann.org, ebiederm@xmission.com,
        davem@davemloft.net, fengguang.wu@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 7/7] sched: Use WARN_ONCE for the might_sleep() TASK_RUNNING test
References: <20141031111037.936236584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-wait-warn.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases this can trigger a true flood of output.

Requested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7301,7 +7301,7 @@ void __might_sleep(const char *file, int
 	 * since we will exit with TASK_RUNNING make sure we enter with it,
 	 * otherwise we will destroy state.
 	 */
-	if (WARN(current->state != TASK_RUNNING,
+	if (WARN_ONCE(current->state != TASK_RUNNING,
 			"do not call blocking ops when !TASK_RUNNING; "
 			"state=%lx set at [<%p>] %pS\n",
 			current->state,


