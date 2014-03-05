Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaCEHTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:19:08 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47239 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaCEHTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:19:03 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 1/6] sched: remove unused SCHED_INIT_NODE
Date: Wed,  5 Mar 2014 15:18:21 +0800
Message-Id: <1394003906-11630-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not used since new numa scheduler init sequence

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/metag/include/asm/topology.h |   27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
index 8e9c0b3..e95f874 100644
--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -3,33 +3,6 @@
 
 #ifdef CONFIG_NUMA
 
-/* sched_domains SD_NODE_INIT for Meta machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 2,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 2,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
-	.max_newidle_lb_cost	= 0,			\
-	.next_decay_max_lb_cost	= jiffies,		\
-}
-
 #define cpu_to_node(cpu)	((void)(cpu), 0)
 #define parent_node(node)	((void)(node), 0)
 
-- 
1.7.9.5

