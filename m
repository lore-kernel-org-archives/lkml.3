Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaE2Gsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:48:39 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:55269 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756914AbaE2Gsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:48:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiwJAPbWhlNXQ3h6/2dsb2JhbABZgwerNwoFAZgegRAXdIJTExwjGIECJBOIRgHXWYVViH2ERwEDj0CKNAGLGIgQgzo7
Date: Thu, 29 May 2014 08:48:33 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/3] init/calibrate.c: use __func__ in logging
Message-Id: <20140529084833.a92a81612085710966b65af6@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-coalesce formats in all pr_info
-use __func__ in pr_notice and pr_info (Calibrating delay -> calibrate_delay()).

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 init/calibrate.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 0d747bb..fb9be44 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -95,8 +95,8 @@ static unsigned long calibrate_delay_direct(void)
 		 * >= 12.5% apart, redo calibration.
 		 */
 		if (start >= post_end)
-			pr_notice("calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
-				  start, post_end);
+			pr_notice("%s() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
+				  __func__, start, post_end);
 		if (start < post_end && pre_start != 0 && pre_end != 0 &&
 		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
 			good_timer_count++;
@@ -132,13 +132,13 @@ static unsigned long calibrate_delay_direct(void)
 		good_timer_count = 0;
 		if ((measured_times[max] - estimate) <
 				(estimate - measured_times[min])) {
-			pr_notice("calibrate_delay_direct() dropping min bogoMips estimate %d = %lu\n",
-				  min, measured_times[min]);
+			pr_notice("%s() dropping min bogoMips estimate %d = %lu\n",
+				  __func__, min, measured_times[min]);
 			measured_times[min] = 0;
 			min = max;
 		} else {
-			pr_notice("calibrate_delay_direct() dropping max bogoMips estimate %d = %lu\n",
-				  max, measured_times[max]);
+			pr_notice("%s() dropping max bogoMips estimate %d = %lu\n",
+				  __func__, max, measured_times[max]);
 			measured_times[max] = 0;
 			max = min;
 		}
@@ -156,8 +156,9 @@ static unsigned long calibrate_delay_direct(void)
 
 	}
 
-	pr_notice("calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.\nProbably due to long platform "
-		  "interrupts. Consider using \"lpj=\" boot option.\n");
+	pr_notice("%s() failed to get a good estimate for loops_per_jiffy.\n"
+		  "Probably due to long platform interrupts. Consider using \"lpj=\" boot option.\n",
+		  __func__);
 	return 0;
 }
 #else
@@ -266,26 +267,26 @@ void calibrate_delay(void)
 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
 		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
 		if (!printed)
-			pr_info("Calibrating delay loop (skipped) "
-				"already calibrated this CPU");
+			pr_info("%s() loop (skipped) already calibrated this CPU",
+				__func__);
 	} else if (preset_lpj) {
 		lpj = preset_lpj;
 		if (!printed)
-			pr_info("Calibrating delay loop (skipped) "
-				"preset value.. ");
+			pr_info("%s() loop (skipped) preset value.. ",
+				__func__);
 	} else if ((!printed) && lpj_fine) {
 		lpj = lpj_fine;
-		pr_info("Calibrating delay loop (skipped), "
-			"value calculated using timer frequency.. ");
+		pr_info("%s() loop (skipped), value calculated using timer frequency.. ",
+			__func__);
 	} else if ((lpj = calibrate_delay_is_known())) {
 		;
 	} else if ((lpj = calibrate_delay_direct()) != 0) {
 		if (!printed)
-			pr_info("Calibrating delay using timer "
-				"specific routine.. ");
+			pr_info("%s() using timer specific routine.. ",
+				__func__);
 	} else {
 		if (!printed)
-			pr_info("Calibrating delay loop... ");
+			pr_info("%s() loop... ", __func__);
 		lpj = calibrate_delay_converge();
 	}
 	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
-- 
1.9.1
