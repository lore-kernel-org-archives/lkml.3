Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3CNKm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:42:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab3CNKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: xiaobing tu <xiaobing.tu@intel.com>, guifang tang <guifang.tang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 76/88] Fix memory leak in cpufreq stats.
Date: Thu, 14 Mar 2013 10:36:09 +0000
Message-Id: <1363257381-15900-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Tu, Xiaobing" <xiaobing.tu@intel.com>

commit e37736777254ce1abc85493a5cacbefe5983b896 upstream.

When system enters sleep, non-boot CPUs will be disabled.
Cpufreq stats sysfs is created when the CPU is up, but it is not
freed when the CPU is going down. This will cause memory leak.

Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
Signed-off-by: guifang tang <guifang.tang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/cpufreq_stats.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index b40ee14..3998316 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -328,6 +328,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		cpufreq_stats_free_sysfs(cpu);
 		break;
 	case CPU_DEAD:
-- 
1.8.1.2

