Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab3KMKJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:09:34 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:51656 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075Ab3KMKJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:09:31 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: OMAP: Fix compilation error 'r & ret undeclared'
Date: Wed, 13 Nov 2013 15:39:23 +0530
Message-Id: <c5d802f9efd94a2fafea738d370feff85272bf9a.1384337302.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a recent change "d4019f0 cpufreq: move freq change notifications to cpufreq
core" few variables (r & ret) are removed by mistake and hence these warnings:

drivers/cpufreq/omap-cpufreq.c: In function omap_target:
drivers/cpufreq/omap-cpufreq.c:64:2: error: ret undeclared (first use in this function)
drivers/cpufreq/omap-cpufreq.c:64:2: note: each undeclared identifier is reported only once for each function it appears in
drivers/cpufreq/omap-cpufreq.c:94:3: error: r undeclared (first use in this function)
drivers/cpufreq/omap-cpufreq.c:116:1: warning: control reaches end of non-void function [-Wreturn-type]

Lets fix them by declaring those variables again.

Reported-by: Sebastian Capella <sebastian.capella@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index be6d143..a0acd0b 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -53,6 +53,7 @@ static unsigned int omap_getspeed(unsigned int cpu)
 
 static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 {
+	int r, ret;
 	struct dev_pm_opp *opp;
 	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
 	unsigned int old_freq, new_freq;
-- 
1.7.12.rc2.18.g61b472e

