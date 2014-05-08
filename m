Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbaEHKn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:43:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaEHKnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:43:16 -0400
Date: Thu, 8 May 2014 03:42:27 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-2b4cfe64dee0d84506b951d81bf55d9891744d25@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, jason.low2@hp.com
In-Reply-To: <1398303035-18255-3-git-send-email-jason.low2@hp.com>
References: <1398303035-18255-3-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Initialize newidle balance stats in sd_numa_init()
Git-Commit-ID: 2b4cfe64dee0d84506b951d81bf55d9891744d25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b4cfe64dee0d84506b951d81bf55d9891744d25
Gitweb:     http://git.kernel.org/tip/2b4cfe64dee0d84506b951d81bf55d9891744d25
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Wed, 23 Apr 2014 18:30:34 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:51:37 +0200

sched/numa: Initialize newidle balance stats in sd_numa_init()

Also initialize the per-sd variables for newidle load balancing
in sd_numa_init().

Signed-off-by: Jason Low <jason.low2@hp.com>
Acked-by: morten.rasmussen@arm.com
Cc: daniel.lezcano@linaro.org
Cc: alex.shi@linaro.org
Cc: preeti@linux.vnet.ibm.com
Cc: efault@gmx.de
Cc: vincent.guittot@linaro.org
Cc: aswin@hp.com
Cc: chegu_vinod@hp.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1398303035-18255-3-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 28921ec..13584f1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6026,6 +6026,8 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					,
 		.last_balance		= jiffies,
 		.balance_interval	= sd_weight,
+		.max_newidle_lb_cost	= 0,
+		.next_decay_max_lb_cost	= jiffies,
 	};
 	SD_INIT_NAME(sd, NUMA);
 	sd->private = &tl->data;
