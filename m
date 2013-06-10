Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab3FJLAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:00:20 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48653 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3FJLAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:00:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] sched: Create for_each_sd_topology()
Date: Mon, 10 Jun 2013 16:27:20 +0530
Message-Id: <e0e04542f54e9464bd9da54f5ccfe62ec6c4c0bc.1370861520.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1370861520.git.viresh.kumar@linaro.org>
References: <cover.1370861520.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1370861520.git.viresh.kumar@linaro.org>
References: <cover.1370861520.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For loop for traversing sched_domain_topology was used at multiple placed in
core.c. This patch removes code redundancy by creating for_each_sd_topology().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a12113d..e585e10 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5552,6 +5552,9 @@ static struct sched_domain_topology_level default_topology[] = {
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+#define for_each_sd_topology(tl)			\
+	for (tl = sched_domain_topology; tl->init; tl++)
+
 #ifdef CONFIG_NUMA
 
 static int sched_domains_numa_levels;
@@ -5849,7 +5852,7 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 	struct sched_domain_topology_level *tl;
 	int j;
 
-	for (tl = sched_domain_topology; tl->init; tl++) {
+	for_each_sd_topology(tl) {
 		struct sd_data *sdd = &tl->data;
 
 		sdd->sd = alloc_percpu(struct sched_domain *);
@@ -5902,7 +5905,7 @@ static void __sdt_free(const struct cpumask *cpu_map)
 	struct sched_domain_topology_level *tl;
 	int j;
 
-	for (tl = sched_domain_topology; tl->init; tl++) {
+	for_each_sd_topology(tl) {
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
@@ -5970,7 +5973,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		struct sched_domain_topology_level *tl;
 
 		sd = NULL;
-		for (tl = sched_domain_topology; tl->init; tl++) {
+		for_each_sd_topology(tl) {
 			sd = build_sched_domain(tl, cpu_map, attr, sd, i);
 			if (tl == sched_domain_topology)
 				*per_cpu_ptr(d.sd, i) = sd;
-- 
1.7.12.rc2.18.g61b472e

