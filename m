Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbaE2GpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:45:11 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:45851 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163AbaE2GpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:45:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiwJAPbWhlNXQ3h6/2dsb2JhbABZgwerNwoFAZgegRAXdIJmHCMYgQIkE4hGAddZhVWIfYRHAQOPQIo0AYsYiBCDOjs
Date: Thu, 29 May 2014 08:45:05 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/3] init/calibrate.c: convert printk(KERN_NOTICE to
 pr_notice
Message-Id: <20140529084505.bec19f03b65d6d0d71a71ac5@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 init/calibrate.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 520702d..0d747bb 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -95,10 +95,8 @@ static unsigned long calibrate_delay_direct(void)
 		 * >= 12.5% apart, redo calibration.
 		 */
 		if (start >= post_end)
-			printk(KERN_NOTICE "calibrate_delay_direct() ignoring "
-					"timer_rate as we had a TSC wrap around"
-					" start=%lu >=post_end=%lu\n",
-				start, post_end);
+			pr_notice("calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
+				  start, post_end);
 		if (start < post_end && pre_start != 0 && pre_end != 0 &&
 		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
 			good_timer_count++;
@@ -134,15 +132,13 @@ static unsigned long calibrate_delay_direct(void)
 		good_timer_count = 0;
 		if ((measured_times[max] - estimate) <
 				(estimate - measured_times[min])) {
-			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
-					"min bogoMips estimate %d = %lu\n",
-				min, measured_times[min]);
+			pr_notice("calibrate_delay_direct() dropping min bogoMips estimate %d = %lu\n",
+				  min, measured_times[min]);
 			measured_times[min] = 0;
 			min = max;
 		} else {
-			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
-					"max bogoMips estimate %d = %lu\n",
-				max, measured_times[max]);
+			pr_notice("calibrate_delay_direct() dropping max bogoMips estimate %d = %lu\n",
+				  max, measured_times[max]);
 			measured_times[max] = 0;
 			max = min;
 		}
@@ -160,9 +156,8 @@ static unsigned long calibrate_delay_direct(void)
 
 	}
 
-	printk(KERN_NOTICE "calibrate_delay_direct() failed to get a good "
-	       "estimate for loops_per_jiffy.\nProbably due to long platform "
-		"interrupts. Consider using \"lpj=\" boot option.\n");
+	pr_notice("calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.\nProbably due to long platform "
+		  "interrupts. Consider using \"lpj=\" boot option.\n");
 	return 0;
 }
 #else
-- 
1.9.1
