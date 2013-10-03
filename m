Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3JCP6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:58:25 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54785 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3JCP6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:58:21 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 12/16] cpuidle: use drv instead of cpuidle_driver in show_current_driver()
Date: Thu,  3 Oct 2013 21:26:51 +0530
Message-Id: <db6ad03989323c290e26eb89a4db7f69a4c7abc8.1380815504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instances of "struct cpuidle_driver *" are consistently named as "drv" in
cpuidle core. Its broken only at one place: show_current_driver().

Fix it for consistency.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index a022393..e918b6d 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -52,12 +52,12 @@ static ssize_t show_current_driver(struct device *dev,
 				   char *buf)
 {
 	ssize_t ret;
-	struct cpuidle_driver *cpuidle_driver;
+	struct cpuidle_driver *drv;
 
 	spin_lock(&cpuidle_driver_lock);
-	cpuidle_driver = cpuidle_get_driver();
-	if (cpuidle_driver)
-		ret = sprintf(buf, "%s\n", cpuidle_driver->name);
+	drv = cpuidle_get_driver();
+	if (drv)
+		ret = sprintf(buf, "%s\n", drv->name);
 	else
 		ret = sprintf(buf, "none\n");
 	spin_unlock(&cpuidle_driver_lock);
-- 
1.7.12.rc2.18.g61b472e

