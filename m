Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbaELVQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:16:38 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54282 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392AbaELVQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:16:36 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: mingo@kernel.org, peterz@infradead.org, jet.chen@intel.com
Cc: fengguang.wu@intel.com, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: sched: fix: initialization of sched_domain_topology for NUMA
Date: Mon, 12 May 2014 23:16:16 +0200
Message-Id: <1399929376-4597-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_domain_topology table is a null terminated array. 
Add 1 row in the allocation size that will be used as the last row of the
table.

Reported-by: Jet Chen <jet.chen@intel.com>
Tested-by: Jet Chen <jet.chen@intel.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
link: https://lkml.org/lkml/2014/5/12/130

---

Hi Ingo and Peter,

This patch fixes the problem that has been reported by Jet Chen 

Regards,
Vincent

 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4ea7b3f..205fa17 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6234,7 +6234,7 @@ static void sched_init_numa(void)
 	/* Compute default topology size */
 	for (i = 0; sched_domain_topology[i].mask; i++);
 
-	tl = kzalloc((i + level) *
+	tl = kzalloc((i + level + 1) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
-- 
1.9.1

