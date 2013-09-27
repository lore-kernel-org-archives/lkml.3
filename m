Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3I0C0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:26:19 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:53523 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3I0CZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:25:30 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH 2/6] cpuidle: calxeda: add cpu_pm_enter/exit calls
Date: Thu, 26 Sep 2013 21:24:50 -0500
Message-Id: <1380248694-13388-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
References: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Wnen powergating the core, we need to call cpu pm notifiers to save VFP
state (!SMP only) and resetting the breakpoint h/w.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org
---
 drivers/cpuidle/cpuidle-calxeda.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
index 01cfecf3..b04767a 100644
--- a/drivers/cpuidle/cpuidle-calxeda.c
+++ b/drivers/cpuidle/cpuidle-calxeda.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/cpuidle.h>
+#include <linux/cpu_pm.h>
 #include <linux/init.h>
 #include <linux/of.h>
 #include <asm/cpuidle.h>
@@ -39,7 +40,10 @@ static int calxeda_pwrdown_idle(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv,
 				int index)
 {
+	cpu_pm_enter();
 	cpu_suspend(0, calxeda_idle_finish);
+	cpu_pm_exit();
+
 	return index;
 }
 
-- 
1.8.1.2

