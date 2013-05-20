Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3ETLM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:12:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab3ETKxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonghwan Choi <jhbird.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 048/115] cpufreq: exynos: Get booting freq value in exynos_cpufreq_init
Date: Mon, 20 May 2013 11:50:48 +0100
Message-Id: <1369047116-9378-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonghwan Choi <jhbird.choi@samsung.com>

commit 6e45eb12fd1c741d556bf264ee98853b5f3104e5 upstream.

Boot_freq is for saving booting freq. But exynos_cpufreq_cpu_init
is called in hotplug. If boot_freq is existed in exynos_cpufreq_cpu_init,
boot_freq could be changed.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/exynos-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index b243a7e..0a28dc3 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -210,8 +210,6 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	cpufreq_frequency_table_get_attr(exynos_info->freq_table, policy->cpu);
 
-	locking_frequency = exynos_getspeed(0);
-
 	/* set the transition latency value */
 	policy->cpuinfo.transition_latency = 100000;
 
@@ -275,6 +273,8 @@ static int __init exynos_cpufreq_init(void)
 		goto err_vdd_arm;
 	}
 
+	locking_frequency = exynos_getspeed(0);
+
 	register_pm_notifier(&exynos_cpufreq_nb);
 
 	if (cpufreq_register_driver(&exynos_driver)) {
-- 
1.8.1.2

