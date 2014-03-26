Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaCZLWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:22:21 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52146 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaCZLWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:18 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 05/14] hrtimer: no need to rewrite '1' to hrtimer_hres_enabled
Date: Wed, 26 Mar 2014 16:51:11 +0530
Message-Id: <f3a2cdd3cf8f8bf09216a4696574e9ee026d9256.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

High Resolution feature can be enabled/disabled from bootargs if we have a
string 'highres=' followed by 'on' or 'off'. The default value of this variable
is '1'.  When 'on' is passed as bootarg, we don't have to overwrite this
variable by '1'.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b0bcc10..e5d81ee 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -503,9 +503,7 @@ static int __init setup_hrtimer_hres(char *str)
 {
 	if (!strcmp(str, "off"))
 		hrtimer_hres_enabled = 0;
-	else if (!strcmp(str, "on"))
-		hrtimer_hres_enabled = 1;
-	else
+	else if (strcmp(str, "on"))
 		return 0;
 	return 1;
 }
-- 
1.7.12.rc2.18.g61b472e

