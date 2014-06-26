Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaFZIvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:51:50 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:39437 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaFZIvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:51:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: report driver's successful {un}registration
Date: Thu, 26 Jun 2014 14:21:30 +0530
Message-Id: <9e68cba2bf41923630ea93de7c3d17637f175895.1403772686.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do report driver's successful {un}registration from cpufreq core, but is done
with pr_debug() and so this doesn't appear in boot logs.

Convert this to pr_info() to make it visible in logs.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 62259d2..63d8f8f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2468,7 +2468,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	}
 
 	register_hotcpu_notifier(&cpufreq_cpu_notifier);
-	pr_debug("driver %s up and running\n", driver_data->name);
+	pr_info("driver %s up and running\n", driver_data->name);
 
 	return 0;
 err_if_unreg:
@@ -2499,7 +2499,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	if (!cpufreq_driver || (driver != cpufreq_driver))
 		return -EINVAL;
 
-	pr_debug("unregistering driver %s\n", driver->name);
+	pr_info("unregistering driver %s\n", driver->name);
 
 	subsys_interface_unregister(&cpufreq_interface);
 	if (cpufreq_boost_supported())
-- 
2.0.0.rc2

