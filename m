Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaDXBbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:31:50 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:45304 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaDXBbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:31:47 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Subject: [PATCH 2/3] sched: Initialize newidle balance stats in sd_numa_init()
Date: Wed, 23 Apr 2014 18:30:34 -0700
Message-Id: <1398303035-18255-3-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also initialize the per-sd variables for newidle load balancing
in sd_numa_init().

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3f12533..b1c6cb9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6030,6 +6030,8 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					,
 		.last_balance		= jiffies,
 		.balance_interval	= sd_weight,
+		.max_newidle_lb_cost	= 0,
+		.next_decay_max_lb_cost	= jiffies,
 	};
 	SD_INIT_NAME(sd, NUMA);
 	sd->private = &tl->data;
-- 
1.7.1

