Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3JIPNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:13:50 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64846 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3JIPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:13:48 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl, badarkhe.manish@gmail.com, viresh.kumar@linaro.org,
        kgene.kim@samsung.com
Subject: [PATCH] cpufreq: fix false return check from "regulator_set_voltage"
Date: Wed,  9 Oct 2013 20:43:37 +0530
Message-Id: <1381331617-14703-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, code checks false return value from "regulator_set_voltage"
to show failure message. Modify the code to check proper return
value from "regulator_set_voltage".

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
Based on master branch of linux-mainline.

:100644 100644 0fac344... 1537f32... M	drivers/cpufreq/exynos-cpufreq.c
 drivers/cpufreq/exynos-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 0fac344..1537f32 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -141,7 +141,7 @@ post_notify:
 	if ((freqs.new < freqs.old) ||
 	   ((freqs.new > freqs.old) && safe_arm_volt)) {
 		/* down the voltage after frequency change */
-		regulator_set_voltage(arm_regulator, arm_volt,
+		ret = regulator_set_voltage(arm_regulator, arm_volt,
 				arm_volt);
 		if (ret) {
 			pr_err("%s: failed to set cpu voltage to %d\n",
-- 
1.7.10.4

