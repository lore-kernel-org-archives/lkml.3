Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3FSSlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:41:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40162 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3FSSlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:41:17 -0400
Date: Wed, 19 Jun 2013 11:40:45 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-27723a68caf05381b0b0bc6e127da2c9e7bcb775@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <e0e04542f54e9464bd9da54f5ccfe62ec6c4c0bc.1370861520.git.viresh.kumar@linaro.org>
References: <e0e04542f54e9464bd9da54f5ccfe62ec6c4c0bc.1370861520.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Create for_each_sd_topology()
Git-Commit-ID: 27723a68caf05381b0b0bc6e127da2c9e7bcb775
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:40:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27723a68caf05381b0b0bc6e127da2c9e7bcb775
Gitweb:     http://git.kernel.org/tip/27723a68caf05381b0b0bc6e127da2c9e7bcb775
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Mon, 10 Jun 2013 16:27:20 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:45 +0200

sched: Create for_each_sd_topology()

For loop for traversing sched_domain_topology was used at multiple placed in
core.c. This patch removes code redundancy by creating for_each_sd_topology().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/e0e04542f54e9464bd9da54f5ccfe62ec6c4c0bc.1370861520.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 88c2c0e..547b7d3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5565,6 +5565,9 @@ static struct sched_domain_topology_level default_topology[] = {
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+#define for_each_sd_topology(tl)			\
+	for (tl = sched_domain_topology; tl->init; tl++)
+
 #ifdef CONFIG_NUMA
 
 static int sched_domains_numa_levels;
@@ -5862,7 +5865,7 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 	struct sched_domain_topology_level *tl;
 	int j;
 
-	for (tl = sched_domain_topology; tl->init; tl++) {
+	for_each_sd_topology(tl) {
 		struct sd_data *sdd = &tl->data;
 
 		sdd->sd = alloc_percpu(struct sched_domain *);
@@ -5915,7 +5918,7 @@ static void __sdt_free(const struct cpumask *cpu_map)
 	struct sched_domain_topology_level *tl;
 	int j;
 
-	for (tl = sched_domain_topology; tl->init; tl++) {
+	for_each_sd_topology(tl) {
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
@@ -5983,7 +5986,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		struct sched_domain_topology_level *tl;
 
 		sd = NULL;
-		for (tl = sched_domain_topology; tl->init; tl++) {
+		for_each_sd_topology(tl) {
 			sd = build_sched_domain(tl, cpu_map, attr, sd, i);
 			if (tl == sched_domain_topology)
 				*per_cpu_ptr(d.sd, i) = sd;
