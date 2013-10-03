Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3JCP5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:57:37 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60830 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3JCP5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:57:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 05/16] cpuidle: make __cpuidle_driver_init() return void
Date: Thu,  3 Oct 2013 21:26:44 +0530
Message-Id: <76a7716af29237a2d5890b0020223cec31cc8b9f.1380815504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpuidle_driver_init() doesn't return anything except zero and so doesn't
really need a return type other than void.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/driver.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 25455e8..ebc6b0f 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -149,10 +149,8 @@ static void cpuidle_setup_broadcast_timer(void *arg)
 /**
  * __cpuidle_driver_init - initialize the driver's internal data
  * @drv: a valid pointer to a struct cpuidle_driver
- *
- * Returns 0 on success, a negative error code otherwise.
  */
-static int __cpuidle_driver_init(struct cpuidle_driver *drv)
+static void __cpuidle_driver_init(struct cpuidle_driver *drv)
 {
 	int i;
 
@@ -179,8 +177,6 @@ static int __cpuidle_driver_init(struct cpuidle_driver *drv)
 		drv->bctimer = 1;
 		break;
 	}
-
-	return 0;
 }
 
 /**
@@ -206,9 +202,7 @@ static int __cpuidle_register_driver(struct cpuidle_driver *drv)
 	if (cpuidle_disabled())
 		return -ENODEV;
 
-	ret = __cpuidle_driver_init(drv);
-	if (ret)
-		return ret;
+	__cpuidle_driver_init(drv);
 
 	ret = __cpuidle_set_driver(drv);
 	if (ret)
-- 
1.7.12.rc2.18.g61b472e

