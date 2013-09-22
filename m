Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3IVBWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:22:13 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53602 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3IVBWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:22:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 07/21] cpuidle: rearrange __cpuidle_register_device() to keep minimal exit points
Date: Sun, 22 Sep 2013 06:50:59 +0530
Message-Id: <2dd257d9843954aaaf0cf30c7fb475daded018a5.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch rearranges __cpuidle_register_device() a bit in order to reduce the
number of exit points of this function.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/cpuidle.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 211e504..8c91bad 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -383,13 +383,12 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	list_add(&dev->device_list, &cpuidle_detected_devices);
 
 	ret = cpuidle_coupled_register_device(dev);
-	if (ret) {
+	if (ret)
 		__cpuidle_unregister_device(dev);
-		return ret;
-	}
+	else
+		dev->registered = 1;
 
-	dev->registered = 1;
-	return 0;
+	return ret;
 }
 
 /**
-- 
1.7.12.rc2.18.g61b472e

