Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3BFRDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:03:52 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38051 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab3BFRCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:02:45 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 4/5] cpufreq_stats: do not remove sysfs files if frequency table is not present
Date: Wed,  6 Feb 2013 09:02:12 -0800
Message-Id: <1360170133-5066-6-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

The sysfs files for cpufreq_stats are created in cpufreq_stats_create_table()
called from cpufreq_stat_notifier_policy() when a policy is added to
the cpu. cpufreq_stats_create_table() will not be called if the
scaling driver does not export a frequency table to cpufreq.  Use the
same fence on tear down.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/cpufreq_stats.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index a2dee4c..2fd779e 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -179,6 +179,10 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 static void cpufreq_stats_free_sysfs(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+
+	if (!cpufreq_frequency_get_table(cpu))
+		return;
+
 	if (policy && !policy_is_shared(policy)) {
 		pr_debug("%s: Free sysfs stat\n", __func__);
 		sysfs_remove_group(&policy->kobj, &stats_attr_group);
-- 
1.7.7.6

