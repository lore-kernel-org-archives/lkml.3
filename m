Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbbAPJF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:05:58 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60365 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752142AbbAPJF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:05:56 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        sylvain.rochet@finsecur.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] clockevents: don't suspend/resume if unused
Date: Fri, 16 Jan 2015 10:05:51 +0100
Message-Id: <1421399151-26800-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in calling suspend/resume for unused
clockevents as they are already stopped and disabled.

Furthermore, it can take some time to wait for some IPs to stop counting.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Reported-by: Sylvain Rochet <sylvain.rochet@finsecur.com>
---
 kernel/time/clockevents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 55449909f114..0eff982c1c11 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -525,7 +525,7 @@ void clockevents_suspend(void)
 	struct clock_event_device *dev;
 
 	list_for_each_entry_reverse(dev, &clockevent_devices, list)
-		if (dev->suspend)
+		if (dev->suspend && dev->mode != CLOCK_EVT_MODE_UNUSED)
 			dev->suspend(dev);
 }
 
@@ -537,7 +537,7 @@ void clockevents_resume(void)
 	struct clock_event_device *dev;
 
 	list_for_each_entry(dev, &clockevent_devices, list)
-		if (dev->resume)
+		if (dev->resume && dev->mode != CLOCK_EVT_MODE_UNUSED)
 			dev->resume(dev);
 }
 
-- 
2.1.0

