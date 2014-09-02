Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaIBVTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:19:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:55115 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaIBVTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:19:37 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 6/9] ARM: zynq: cpuidle: Remove pointless code
Date: Tue,  2 Sep 2014 14:19:11 -0700
Message-Id: <1409692754-13437-7-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
In-Reply-To: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

The core is not powered down, it is pointless to call the cpu_pm notifiers and
switch to the global timer.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-and-tested-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/cpuidle/cpuidle-zynq.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-zynq.c b/drivers/cpuidle/cpuidle-zynq.c
index aded75928028..c61b8b2a7c77 100644
--- a/drivers/cpuidle/cpuidle-zynq.c
+++ b/drivers/cpuidle/cpuidle-zynq.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/cpu_pm.h>
 #include <linux/cpuidle.h>
 #include <linux/platform_device.h>
 #include <asm/proc-fns.h>
@@ -38,15 +37,9 @@
 static int zynq_enter_idle(struct cpuidle_device *dev,
 			   struct cpuidle_driver *drv, int index)
 {
-	/* Devices must be stopped here */
-	cpu_pm_enter();
-
 	/* Add code for DDR self refresh start */
 	cpu_do_idle();
 
-	/* Add code for DDR self refresh stop */
-	cpu_pm_exit();
-
 	return index;
 }
 
@@ -59,8 +52,7 @@ static struct cpuidle_driver zynq_idle_driver = {
 			.enter			= zynq_enter_idle,
 			.exit_latency		= 10,
 			.target_residency	= 10000,
-			.flags			= CPUIDLE_FLAG_TIME_VALID |
-						  CPUIDLE_FLAG_TIMER_STOP,
+			.flags			= CPUIDLE_FLAG_TIME_VALID,
 			.name			= "RAM_SR",
 			.desc			= "WFI and RAM Self Refresh",
 		},
-- 
2.1.0.1.g27b9230

