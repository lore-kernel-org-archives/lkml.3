Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbaEQEv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 00:51:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56917 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbaEQEvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 00:51:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, nicolas.pitre@linaro.org, swarren@wwwdotorg.org,
        dianders@chromium.org, linux@arm.linux.org.uk,
        thomas.abraham@linaro.org, pdeschrijver@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 3/4] cpufreq: Tegra: drop wrapper around tegra_update_cpu_speed()
Date: Sat, 17 May 2014 10:21:22 +0530
Message-Id: <898b7b84ba61d89bc2cebb63111a745ec633a02e.1400302114.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400302114.git.viresh.kumar@linaro.org>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400302114.git.viresh.kumar@linaro.org>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra has implemented an unnecessary wrapper over tegra_update_cpu_speed(), i.e.
tegra_target(), which wasn't doing anything apart of calling
tegra_update_cpu_speed(). Get rid of that and use tegra_target() directly.

Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 63f0059..6e774c6 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -82,9 +82,9 @@ out:
 	return ret;
 }
 
-static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
-		unsigned long rate)
+static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 {
+	unsigned long rate = freq_table[index].frequency;
 	int ret = 0;
 
 	/*
@@ -106,11 +106,6 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	return ret;
 }
 
-static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
-{
-	return tegra_update_cpu_speed(policy, freq_table[index].frequency);
-}
-
 static int tegra_cpu_init(struct cpufreq_policy *policy)
 {
 	int ret;
-- 
2.0.0.rc2

