Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3IVBWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:22:05 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56683 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3IVBWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:22:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 06/21] cpuidle: rearrange code in __cpuidle_driver_init()
Date: Sun, 22 Sep 2013 06:50:58 +0530
Message-Id: <72ec40529db737fe0eea6d14fc43fa332f9c5d59.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is trivial patch that just reorders few statements in
__cpuidle_driver_init() routine, so that we don't need both 'continue' and
'break' in the for loop. Functionally it shouldn't change anything.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/driver.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 8df66c8..6279e1c 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -172,12 +172,10 @@ static void __cpuidle_driver_init(struct cpuidle_driver *drv)
 	 * order, because usually one of the deeper states have this flag set.
 	 */
 	for (i = drv->state_count - 1; i >= 0 ; i--) {
-
-		if (!(drv->states[i].flags & CPUIDLE_FLAG_TIMER_STOP))
-			continue;
-
-		drv->bctimer = 1;
-		break;
+		if (drv->states[i].flags & CPUIDLE_FLAG_TIMER_STOP) {
+			drv->bctimer = 1;
+			break;
+		}
 	}
 }
 
-- 
1.7.12.rc2.18.g61b472e

