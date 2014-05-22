Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaEVM2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:28:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaEVM2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:28:30 -0400
Date: Thu, 22 May 2014 05:27:36 -0700
From: tip-bot for Dietmar Eggemann <tipbot@zytor.com>
Message-ID: <tip-caffcdd8d27ba78730d5540396ce72ad022aff2c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, dietmar.eggemann@arm.com,
        Dietmar.Eggemann@arm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Dietmar.Eggemann@arm.com, dietmar.eggemann@arm.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1398865178-12577-1-git-send-email-dietmar.eggemann@arm.com>
References: <1398865178-12577-1-git-send-email-dietmar.eggemann@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Do not zero sg->cpumask and sg->sgp->
 power in build_sched_groups()
Git-Commit-ID: caffcdd8d27ba78730d5540396ce72ad022aff2c
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

Commit-ID:  caffcdd8d27ba78730d5540396ce72ad022aff2c
Gitweb:     http://git.kernel.org/tip/caffcdd8d27ba78730d5540396ce72ad022aff2c
Author:     Dietmar Eggemann <Dietmar.Eggemann@arm.com>
AuthorDate: Wed, 30 Apr 2014 14:39:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 11:16:30 +0200

sched: Do not zero sg->cpumask and sg->sgp->power in build_sched_groups()

There is no need to zero struct sched_group member cpumask and struct
sched_group_power member power since both structures are already allocated
as zeroed memory in __sdt_alloc().

This patch has been tested with
BUG_ON(!cpumask_empty(sched_group_cpus(sg))); and BUG_ON(sg->sgp->power);
in build_sched_groups() on ARM TC2 and INTEL i5 M520 platform including
CPU hotplug scenarios.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1398865178-12577-1-git-send-email-dietmar.eggemann@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 45d077e..6340c60 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5794,8 +5794,6 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		group = get_group(i, sdd, &sg);
-		cpumask_clear(sched_group_cpus(sg));
-		sg->sgp->power = 0;
 		cpumask_setall(sched_group_mask(sg));
 
 		for_each_cpu(j, span) {
