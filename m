Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3HVH74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:59:56 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45840 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3HVH7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:59:55 -0400
Message-ID: <5215C4F1.1070908@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:59:45 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/11] sched/cleanup: remove the extra parm of find_new_ilb()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-2674-0000-0000-00000A55C462
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parm 'call_cpu' has not been used, remove it to make code clean.

CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 05643d6..29ac8dd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5454,7 +5454,7 @@ static struct {
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
-static inline int find_new_ilb(int call_cpu)
+static inline int find_new_ilb(void)
 {
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
 
@@ -5475,7 +5475,7 @@ static void nohz_balancer_kick(int cpu)
 
 	nohz.next_balance++;
 
-	ilb_cpu = find_new_ilb(cpu);
+	ilb_cpu = find_new_ilb();
 
 	if (ilb_cpu >= nr_cpu_ids)
 		return;
-- 
1.7.9.5

