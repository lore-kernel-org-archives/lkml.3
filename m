Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab3IMN4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:56:44 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59216 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949Ab3IMNNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:13:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 085/228] cpufreq: sh: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:31 +0530
Message-Id: <74417e54eb4b55ce4c54f24c3c39c2ea1cfde3f1.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sh-cpufreq.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/cpufreq/sh-cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
index f1fb944..c681b86 100644
--- a/drivers/cpufreq/sh-cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -151,11 +151,6 @@ static int sh_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static struct freq_attr *sh_freq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver sh_cpufreq_driver = {
 	.name		= "sh",
 	.get		= sh_cpufreq_get,
@@ -163,7 +158,7 @@ static struct cpufreq_driver sh_cpufreq_driver = {
 	.verify		= sh_cpufreq_verify,
 	.init		= sh_cpufreq_cpu_init,
 	.exit		= sh_cpufreq_cpu_exit,
-	.attr		= sh_freq_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static int __init sh_cpufreq_module_init(void)
-- 
1.7.12.rc2.18.g61b472e

