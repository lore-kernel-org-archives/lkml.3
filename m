Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab3EGD7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:59:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760099Ab3EGD6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:50 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=AUOJRdBA_U4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=I54kO7_LYcIA:10 a=hD80L64hAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=v3rLFGiuRE8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035846.500872147@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [034/126] cpufreq: exynos: Get booting freq value in exynos_cpufreq_init
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0034-cpufreq-exynos-Get-booting-freq-value-in-exynos_cpuf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jonghwan Choi <jhbird.choi@samsung.com>

[ Upstream commit 6e45eb12fd1c741d556bf264ee98853b5f3104e5 ]

Boot_freq is for saving booting freq. But exynos_cpufreq_cpu_init
is called in hotplug. If boot_freq is existed in exynos_cpufreq_cpu_init,
boot_freq could be changed.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/cpufreq/exynos-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index af2d81e..8cf7a38 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -220,8 +220,6 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	cpufreq_frequency_table_get_attr(exynos_info->freq_table, policy->cpu);
 
-	locking_frequency = exynos_getspeed(0);
-
 	/* set the transition latency value */
 	policy->cpuinfo.transition_latency = 100000;
 
@@ -285,6 +283,8 @@ static int __init exynos_cpufreq_init(void)
 		goto err_vdd_arm;
 	}
 
+	locking_frequency = exynos_getspeed(0);
+
 	register_pm_notifier(&exynos_cpufreq_nb);
 
 	if (cpufreq_register_driver(&exynos_driver)) {
-- 
1.7.10.4


