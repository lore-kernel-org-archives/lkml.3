Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaHMR1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:27:53 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:44237 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaHMR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:27:51 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org (open list:SCHEDULER)
Subject: [PATCH 1/1] sched: Match declaration with definition
Date: Wed, 13 Aug 2014 13:28:12 -0400
Message-Id: <1407950893-32731-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Match the declaration of runqueues with the definition.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/sched/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 579712f..4c2b87f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -647,7 +647,7 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
-DECLARE_PER_CPU(struct rq, runqueues);
+DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
-- 
1.9.1

