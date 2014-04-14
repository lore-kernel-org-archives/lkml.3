Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaDNQ0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:26:31 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61625 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbaDNQ0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:26:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 21/38] tick-sched: no need to rewrite '1' to tick_nohz_enabled
Date: Mon, 14 Apr 2014 21:53:43 +0530
Message-Id: <65eb0d37413fa94b7b1f6d152550d8cc599b87cc.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NO_HZ feature can be enabled/disabled from bootargs if we have a string 'nohz='
followed by 'on' or 'off'. The default value of this variable is '1'.  When 'on'
is passed as bootarg, we don't have to overwrite this variable by '1'.

Also, an extra blank line is removed.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e9f9f87..9cbba513 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -370,13 +370,10 @@ static int __init setup_tick_nohz(char *str)
 {
 	if (!strcmp(str, "off"))
 		tick_nohz_enabled = 0;
-	else if (!strcmp(str, "on"))
-		tick_nohz_enabled = 1;
-	else
+	else if (strcmp(str, "on"))
 		return 0;
 	return 1;
 }
-
 __setup("nohz=", setup_tick_nohz);
 
 /**
-- 
1.7.12.rc2.18.g61b472e

