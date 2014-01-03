Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaACEDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 23:03:19 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37436 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaACEDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 23:03:18 -0500
Message-ID: <1388721792.4741.0.camel@phoenix>
Subject: [PATCH] clocksource: mxs_timer: Get rid of mxs_clockevent_mode
 variable
From: Axel Lin <axel.lin@ingics.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Jan 2014 12:03:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current mode setting is stored in mode field of struct clock_event_device.
So we can just remove the mxs_clockevent_mode variable.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/clocksource/mxs_timer.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/mxs_timer.c b/drivers/clocksource/mxs_timer.c
index 0f5e65f..d7d5f11 100644
--- a/drivers/clocksource/mxs_timer.c
+++ b/drivers/clocksource/mxs_timer.c
@@ -77,7 +77,6 @@
 #define BV_TIMROTv2_TIMCTRLn_SELECT__TICK_ALWAYS	0xf
 
 static struct clock_event_device mxs_clockevent_device;
-static enum clock_event_mode mxs_clockevent_mode = CLOCK_EVT_MODE_UNUSED;
 
 static void __iomem *mxs_timrot_base;
 static u32 timrot_major_version;
@@ -156,7 +155,7 @@ static void mxs_set_mode(enum clock_event_mode mode,
 	/* Disable interrupt in timer module */
 	timrot_irq_disable();
 
-	if (mode != mxs_clockevent_mode) {
+	if (mode != evt->mode) {
 		/* Set event time into the furthest future */
 		if (timrot_is_v1())
 			__raw_writel(0xffff,
@@ -171,13 +170,10 @@ static void mxs_set_mode(enum clock_event_mode mode,
 
 #ifdef DEBUG
 	pr_info("%s: changing mode from %s to %s\n", __func__,
-		clock_event_mode_label[mxs_clockevent_mode],
+		clock_event_mode_label[evt->mode],
 		clock_event_mode_label[mode]);
 #endif /* DEBUG */
 
-	/* Remember timer mode */
-	mxs_clockevent_mode = mode;
-
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		pr_err("%s: Periodic mode is not implemented\n", __func__);
-- 
1.8.1.2




