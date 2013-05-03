Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab3ECRgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:36:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61404 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760996Ab3ECRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:36:18 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH 2/2] init: calibrate: don't print out bogomips value on boot
Date: Fri,  3 May 2013 18:35:47 +0100
Message-Id: <1367602547-19322-3-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BogoMIPs is a confusing concept, so allow architectures to print it only
if they find it worthwhile. The delay calibration code should stick to
lpj and avoid trying to draw any correlation with BogoMIPs, which may be
a fixed, bogus (geddit?) value.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 init/calibrate.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index fda0a7b..cf48068 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -135,13 +135,13 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 		if ((measured_times[max] - estimate) <
 				(estimate - measured_times[min])) {
 			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
-					"min bogoMips estimate %d = %lu\n",
+					"min delay estimate %d = %lu\n",
 				min, measured_times[min]);
 			measured_times[min] = 0;
 			min = max;
 		} else {
 			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
-					"max bogoMips estimate %d = %lu\n",
+					"max delay estimate %d = %lu\n",
 				max, measured_times[max]);
 			measured_times[max] = 0;
 			max = min;
@@ -292,9 +292,7 @@ void __cpuinit calibrate_delay(void)
 	}
 	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
 	if (!printed)
-		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
-			lpj/(500000/HZ),
-			(lpj/(5000/HZ)) % 100, lpj);
+		pr_cont("lpj=%lu\n", lpj);
 
 	loops_per_jiffy = lpj;
 	printed = true;
-- 
1.8.2.2

