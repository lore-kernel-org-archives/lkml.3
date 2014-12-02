Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaLBOHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:07:24 -0500
Received: from service88.mimecast.com ([195.130.217.12]:50892 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaLBOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:07:06 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [RFC PATCH 07/10] sched: Get rid of scaling usage by cpu_capacity_orig
Date: Tue,  2 Dec 2014 14:06:29 +0000
Message-Id: <1417529192-11579-8-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 02 Dec 2014 14:06:58.0322 (UTC) FILETIME=[3C698F20:01D00E39]
X-MC-Unique: 114120214065823601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2E7VYe016960

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Since now we have besides frequency invariant also cpu (uarch plus max
system frequency) invariant cfs_rq::utilization_load_avg both, frequency
and cpu scaling happens as part of the load tracking.
So cfs_rq::utilization_load_avg does not have to be scaled by the original
capacity of the cpu again.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/fair.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5c4c989..090223f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4806,12 +4806,11 @@ static int select_idle_sibling(struct task_struct *p, int target)
 static int get_cpu_usage(int cpu)
 {
 	unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
-	unsigned long capacity = capacity_orig_of(cpu);
 
 	if (usage >= SCHED_LOAD_SCALE)
-		return capacity;
+		return capacity_orig_of(cpu);
 
-	return (usage * capacity) >> SCHED_LOAD_SHIFT;
+	return usage;
 }
 
 /*
-- 
1.9.1


