Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaDDGwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:52:05 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44011 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaDDGkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:52 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 11/36] hrtimer: no need to rewrite '1' to hrtimer_hres_enabled
Date: Fri,  4 Apr 2014 12:05:54 +0530
Message-Id: <075a5a0fd19ed3470cd7bf784c61d72b2ff0e228.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
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
index 04e4c77..b0fbf12 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -509,9 +509,7 @@ static int __init setup_hrtimer_hres(char *str)
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

