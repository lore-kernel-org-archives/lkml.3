Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaDUJ64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:58:56 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:42274 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaDUJ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 13/19] tick-common: remove local variable 'broadcast' from tick_resume()
Date: Mon, 21 Apr 2014 15:25:09 +0530
Message-Id: <59f9a0281bac84fe356ed3d0f54ae371ad1e430d.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'broadcast' is used just once and we can use tick_resume_broadcast() directly
instead. Also it changes the code a bit to get rid of extra indentation level
which was forcing us to break function calls into two lines.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 85ee9fd..2dc6822 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -350,17 +350,16 @@ void tick_resume(void)
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

