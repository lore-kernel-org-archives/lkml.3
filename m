Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3IVBWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:22:25 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47096 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3IVBWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:22:21 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 09/21] cpuidle: merge two if() statements for checking error cases
Date: Sun, 22 Sep 2013 06:51:01 +0530
Message-Id: <63116bb9adaf7336a019ce087fbe17c4ace81cea.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both return same error message and so better write them in a single line.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/cpuidle.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index aec9029..b8c63cb 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -119,10 +119,7 @@ int cpuidle_idle_call(void)
 	struct cpuidle_driver *drv;
 	int next_state, entered_state;
 
-	if (cpuidle_disabled())
-		return -ENODEV;
-
-	if (!initialized)
+	if (cpuidle_disabled() || !initialized)
 		return -ENODEV;
 
 	/* check if the device is ready */
-- 
1.7.12.rc2.18.g61b472e

