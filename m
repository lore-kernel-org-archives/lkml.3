Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab3CFOlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:41:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44330 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3CFOlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:41:21 -0500
Date: Wed, 6 Mar 2013 06:40:04 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-15f803c94bd92b17708aad9e74226fd0b2c9130c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5135A7AF.8010900@huawei.com>
References: <5135A7AF.8010900@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make default_scale_freq_power() static
Git-Commit-ID: 15f803c94bd92b17708aad9e74226fd0b2c9130c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:40:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15f803c94bd92b17708aad9e74226fd0b2c9130c
Gitweb:     http://git.kernel.org/tip/15f803c94bd92b17708aad9e74226fd0b2c9130c
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 16:07:11 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:24:34 +0100

sched: Make default_scale_freq_power() static

As default_scale_{freq,smt}_power() and update_rt_power() are
used in kernel/sched/fair.c only, annotate them as static
functions.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5135A7AF.8010900@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
