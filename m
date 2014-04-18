Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaDRLzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:55:41 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34402 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaDRLzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:55:38 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
        preeti@linux.vnet.ibm.com, linaro-kernel@lists.linaro.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        cmetcalf@tilera.com, benh@kernel.crashing.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] fix: sched: rework of sched_domain topology definition
Date: Fri, 18 Apr 2014 13:54:25 +0200
Message-Id: <1397822065-26210-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140418105801.GV11182@twins.programming.kicks-ass.net>
References: <20140418105801.GV11182@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_sched_topology doesn't need to be defined for non SMP because
there is no sched_domain

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d2b981c..674b1fa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1047,8 +1047,6 @@ static inline bool cpus_share_cache(int this_cpu, int that_cpu)
 	return true;
 }
 
-static inline void set_sched_topology(struct sched_domain_topology_level *tl) { }
-
 #endif	/* !CONFIG_SMP */
 
 
-- 
1.9.1

