Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3CEIHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:07:53 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:63997 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3CEIHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:07:50 -0500
Message-ID: <5135A7AF.8010900@huawei.com>
Date: Tue, 5 Mar 2013 16:07:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/9] sched: Make default_scale_freq_power() static
References: <5135A736.8050104@huawei.com>
In-Reply-To: <5135A736.8050104@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As default_scale_{freq,smt}_power() and update_rt_power() are used
in kernel/sched/fair.c only, annotate them as static functions.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/sched.h | 3 ---
 kernel/sched/fair.c   | 6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 04b834f..eadd113 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -880,9 +880,6 @@ extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 cpumask_var_t *alloc_sched_domains(unsigned int ndoms);
 void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
 
-unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
-unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
-
 bool cpus_share_cache(int this_cpu, int that_cpu);
 
 #else /* CONFIG_SMP */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..9f23112 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4245,7 +4245,7 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 	return load_idx;
 }
 
-unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
+static unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return SCHED_POWER_SCALE;
 }
@@ -4255,7 +4255,7 @@ unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
 	return default_scale_freq_power(sd, cpu);
 }
 
-unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
+static unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = sd->span_weight;
 	unsigned long smt_gain = sd->smt_gain;
@@ -4270,7 +4270,7 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 	return default_scale_smt_power(sd, cpu);
 }
 
-unsigned long scale_rt_power(int cpu)
+static unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available, age_stamp, avg;
-- 
1.8.0.2
