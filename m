Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3IVBV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:21:58 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56004 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3IVBVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:21:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 05/21] cpuidle: make __cpuidle_driver_init() return void
Date: Sun, 22 Sep 2013 06:50:57 +0530
Message-Id: <70ae3eb991bded7c9768ae7934973943c2a1bf05.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpuidle_driver_init() doesn't return anything except zero and so doesn't
really need a return type other than void.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/driver.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 25455e8..8df66c8 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -152,7 +152,7 @@ static void cpuidle_setup_broadcast_timer(void *arg)
  *
  * Returns 0 on success, a negative error code otherwise.
  */
-static int __cpuidle_driver_init(struct cpuidle_driver *drv)
+static void __cpuidle_driver_init(struct cpuidle_driver *drv)
 {
 	int i;
 
@@ -179,8 +179,6 @@ static int __cpuidle_driver_init(struct cpuidle_driver *drv)
 		drv->bctimer = 1;
 		break;
 	}
-
-	return 0;
 }
 
 /**
@@ -206,9 +204,7 @@ static int __cpuidle_register_driver(struct cpuidle_driver *drv)
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

