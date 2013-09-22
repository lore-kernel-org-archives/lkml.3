Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3IVBVw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:21:52 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54843 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3IVBVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:21:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 04/21] cpuidle: make __cpuidle_device_init() return void
Date: Sun, 22 Sep 2013 06:50:56 +0530
Message-Id: <bb2892017d3ccc78c49c83919c9ee5be2e66dcfd.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpuidle_device_init() doesn't return anything except zero and so doesn't
really need a return type other than void.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/cpuidle.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 8827c02..211e504 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -358,12 +358,10 @@ static void __cpuidle_unregister_device(struct cpuidle_device *dev)
 	module_put(drv->owner);
 }
 
-static int __cpuidle_device_init(struct cpuidle_device *dev)
+static void __cpuidle_device_init(struct cpuidle_device *dev)
 {
 	memset(dev->states_usage, 0, sizeof(dev->states_usage));
 	dev->last_residency = 0;
-
-	return 0;
 }
 
 /**
@@ -410,9 +408,7 @@ int cpuidle_register_device(struct cpuidle_device *dev)
 	if (dev->registered)
 		goto out_unlock;
 
-	ret = __cpuidle_device_init(dev);
-	if (ret)
-		goto out_unlock;
+	__cpuidle_device_init(dev);
 
 	ret = __cpuidle_register_device(dev);
 	if (ret)
-- 
1.7.12.rc2.18.g61b472e

