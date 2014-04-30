Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbaD3Njk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:39:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45506 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaD3Nji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:39:38 -0400
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: [PATCH] sched: Do not zero sg->cpumask and sg->sgp->power in build_sched_groups
Date: Wed, 30 Apr 2014 14:39:38 +0100
Message-Id: <1398865178-12577-1-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 30 Apr 2014 13:39:50.0691 (UTC) FILETIME=[A90AC730:01CF6479]
X-MC-Unique: 114043014393700501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s3UDdoaP007813

From: Dietmar Eggemann <Dietmar.Eggemann@arm.com>

There is no need to zero struct sched_group member cpumask and struct
sched_group_power member power since both structures are already allocated
as zeroed memory in __sdt_alloc().

This patch has been tested with
BUG_ON(!cpumask_empty(sched_group_cpus(sg))); and BUG_ON(sg->sgp->power);
in build_sched_groups() on ARM TC2 and INTEL i5 M520 platform including
CPU hotplug scenarios.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9cae286824bb..6bc51aebbf1b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5807,8 +5807,6 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		group = get_group(i, sdd, &sg);
-		cpumask_clear(sched_group_cpus(sg));
-		sg->sgp->power = 0;
 		cpumask_setall(sched_group_mask(sg));
 
 		for_each_cpu(j, span) {
-- 
1.7.9.5


