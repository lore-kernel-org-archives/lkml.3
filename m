Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbaDNQmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:42:06 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54899 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbaDNQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:26:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 19/38] tick-common: remove local variable 'broadcast' from tick_resume()
Date: Mon, 14 Apr 2014 21:53:41 +0530
Message-Id: <bc4cbfc90e50661634992760c1130acaab248e7d.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'broadcast' is used just once and we can easily use tick_resume_broadcast()
directly instead. Also it changes the code a bit to get rid of extra indentation
level which was forcing us to break function calls into two lines.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 3954f4d..e1b2947 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -351,17 +351,16 @@ void tick_resume(void)
 {
 	struct tick_device *td = tick_get_cpu_device();
 	struct clock_event_device *dev = td->evtdev;
-	int broadcast = tick_resume_broadcast();
 
 	clockevents_set_mode(dev, CLOCK_EVT_MODE_RESUME);
 
-	if (!broadcast) {
-		if (td->mode == TICKDEV_MODE_PERIODIC)
-			tick_setup_periodic(dev, 0);
-		else
-			tick_setup_oneshot(dev, dev->event_handler,
-					   ktime_get());
-	}
+	if (tick_resume_broadcast())
+		return;
+
+	if (td->mode == TICKDEV_MODE_PERIODIC)
+		tick_setup_periodic(dev, 0);
+	else
+		tick_setup_oneshot(dev, dev->event_handler, ktime_get());
 }
 
 /**
-- 
1.7.12.rc2.18.g61b472e

