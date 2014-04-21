Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaDUJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:57:24 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62517 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaDUJ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:57:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 19/19] tick-sched: rearrange code in tick_do_update_jiffies64()
Date: Mon, 21 Apr 2014 15:25:15 +0530
Message-Id: <c0c4a829b4f938d002adb79f2661474be913acee.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last two lines of tick_do_update_jiffies64() are only executed when
'delta.tv64 >= tick_period.tv64'. Move them to the 'if' block to make it more
clear.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 77084fa..0647589 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -84,12 +84,12 @@ static void tick_do_update_jiffies64(ktime_t now)
 
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
+
+		write_sequnlock(&jiffies_lock);
+		update_wall_time();
 	} else {
 		write_sequnlock(&jiffies_lock);
-		return;
 	}
-	write_sequnlock(&jiffies_lock);
-	update_wall_time();
 }
 
 /*
-- 
1.7.12.rc2.18.g61b472e

