Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab3IMNWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:22:12 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37405 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933934Ab3IMNWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:22:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 162/228] cpufreq: longhaul: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:48 +0530
Message-Id: <a618768d1399bbf05f00b5d95a9511577db40432.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/longhaul.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 14df497..45bafdd 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -626,21 +626,12 @@ static void longhaul_setup_voltagescaling(void)
 
 
 static int longhaul_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq, unsigned int relation)
+			    unsigned int table_index)
 {
-	unsigned int table_index = 0;
 	unsigned int i;
 	unsigned int dir = 0;
 	u8 vid, current_vid;
 
-	if (cpufreq_frequency_table_target(policy, longhaul_table, target_freq,
-				relation, &table_index))
-		return -EINVAL;
-
-	/* Don't set same frequency again */
-	if (longhaul_index == table_index)
-		return 0;
-
 	if (!can_scale_voltage)
 		longhaul_setstate(policy, table_index);
 	else {
@@ -919,7 +910,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver longhaul_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= longhaul_target,
+	.target_index = longhaul_target,
 	.get	= longhaul_get,
 	.init	= longhaul_cpu_init,
 	.exit	= cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e

