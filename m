Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaJKQbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:31:33 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:60543 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaJKQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:31:32 -0400
From: Rasmus Wriedt Larsen <rasmuswriedtlarsen@gmail.com>
To: pdeschrijver@nvidia.com
Cc: rmk+kernel@arm.linux.org.uk, swarren@nvidia.com,
        linux-kernel@vger.kernel.org,
        Rasmus Wriedt Larsen <rasmuswriedtlarsen@gmail.com>
Subject: [PATCH] init: calibrate: fix style issues
Date: Sat, 11 Oct 2014 18:31:15 +0200
Message-Id: <1413045075-10416-1-git-send-email-rasmuswriedtlarsen@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* fix multiple quoted string split across lines style issues
* change printk(KERN_NOTICE to pr_notice
* insert spaces after , in function call

Signed-off-by: Rasmus Wriedt Larsen <rasmuswriedtlarsen@gmail.com>
---
 init/calibrate.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index ce635dc..3cfd911 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -15,7 +15,7 @@ unsigned long lpj_fine;
 unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
 {
-	preset_lpj = simple_strtoul(str,NULL,0);
+	preset_lpj = simple_strtoul(str, NULL, 0);
 	return 1;
 }
 
@@ -40,11 +40,13 @@ static unsigned long calibrate_delay_direct(void)
 	unsigned long good_timer_sum = 0;
 	unsigned long good_timer_count = 0;
 	unsigned long measured_times[MAX_DIRECT_CALIBRATION_RETRIES];
-	int max = -1; /* index of measured_times with max/min values or not set */
+
+	/* index of measured_times with max/min values or not set */
+	int max = -1;
 	int min = -1;
 	int i;
 
-	if (read_current_timer(&pre_start) < 0 )
+	if (read_current_timer(&pre_start) < 0)
 		return 0;
 
 	/*
@@ -95,9 +97,7 @@ static unsigned long calibrate_delay_direct(void)
 		 * >= 12.5% apart, redo calibration.
 		 */
 		if (start >= post_end)
-			printk(KERN_NOTICE "calibrate_delay_direct() ignoring "
-					"timer_rate as we had a TSC wrap around"
-					" start=%lu >=post_end=%lu\n",
+			pr_notice("calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
 				start, post_end);
 		if (start < post_end && pre_start != 0 && pre_end != 0 &&
 		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
@@ -134,14 +134,12 @@ static unsigned long calibrate_delay_direct(void)
 		good_timer_count = 0;
 		if ((measured_times[max] - estimate) <
 				(estimate - measured_times[min])) {
-			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
-					"min bogoMips estimate %d = %lu\n",
+			pr_notice("calibrate_delay_direct() dropping min bogoMips estimate %d = %lu\n",
 				min, measured_times[min]);
 			measured_times[min] = 0;
 			min = max;
 		} else {
-			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
-					"max bogoMips estimate %d = %lu\n",
+			pr_notice("calibrate_delay_direct() dropping max bogoMips estimate %d = %lu\n",
 				max, measured_times[max]);
 			measured_times[max] = 0;
 			max = min;
@@ -160,9 +158,7 @@ static unsigned long calibrate_delay_direct(void)
 
 	}
 
-	printk(KERN_NOTICE "calibrate_delay_direct() failed to get a good "
-	       "estimate for loops_per_jiffy.\nProbably due to long platform "
-		"interrupts. Consider using \"lpj=\" boot option.\n");
+	pr_notice("calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.\nProbably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");
 	return 0;
 }
 #else
@@ -280,23 +276,19 @@ void calibrate_delay(void)
 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
 		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
 		if (!printed)
-			pr_info("Calibrating delay loop (skipped) "
-				"already calibrated this CPU");
+			pr_info("Calibrating delay loop (skipped) already calibrated this CPU");
 	} else if (preset_lpj) {
 		lpj = preset_lpj;
 		if (!printed)
-			pr_info("Calibrating delay loop (skipped) "
-				"preset value.. ");
+			pr_info("Calibrating delay loop (skipped) preset value.. ");
 	} else if ((!printed) && lpj_fine) {
 		lpj = lpj_fine;
-		pr_info("Calibrating delay loop (skipped), "
-			"value calculated using timer frequency.. ");
+		pr_info("Calibrating delay loop (skipped), value calculated using timer frequency.. ");
 	} else if ((lpj = calibrate_delay_is_known())) {
 		;
 	} else if ((lpj = calibrate_delay_direct()) != 0) {
 		if (!printed)
-			pr_info("Calibrating delay using timer "
-				"specific routine.. ");
+			pr_info("Calibrating delay using timer specific routine.. ");
 	} else {
 		if (!printed)
 			pr_info("Calibrating delay loop... ");
-- 
1.9.1

