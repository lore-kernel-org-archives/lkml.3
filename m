Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaEWKwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:52:31 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37865 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaEWKby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:31:54 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/71] clocksource: sh_cmt: Hardcode CMT clock event rating to 125
Date: Fri, 23 May 2014 12:30:54 +0200
Message-Id: <1400841111-6683-14-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

All boards use or should use a clock event rating of 125 for the CMT,
hardcode it in the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 926abe2..75b1f83 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -768,14 +768,14 @@ static void sh_cmt_clock_event_resume(struct clock_event_device *ced)
 }
 
 static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
-				       const char *name, unsigned long rating)
+				       const char *name)
 {
 	struct clock_event_device *ced = &ch->ced;
 
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
-	ced->rating = rating;
+	ced->rating = 125;
 	ced->cpumask = cpu_possible_mask;
 	ced->set_next_event = sh_cmt_clock_event_next;
 	ced->set_mode = sh_cmt_clock_event_mode;
@@ -788,11 +788,10 @@ static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
 }
 
 static int sh_cmt_register(struct sh_cmt_channel *ch, const char *name,
-			   unsigned long clockevent_rating,
-			   unsigned long clocksource_rating)
+			   bool clockevent, unsigned long clocksource_rating)
 {
-	if (clockevent_rating)
-		sh_cmt_register_clockevent(ch, name, clockevent_rating);
+	if (clockevent)
+		sh_cmt_register_clockevent(ch, name);
 
 	if (clocksource_rating)
 		sh_cmt_register_clocksource(ch, name, clocksource_rating);
@@ -827,7 +826,7 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 	raw_spin_lock_init(&ch->lock);
 
 	ret = sh_cmt_register(ch, dev_name(&cmt->pdev->dev),
-			      cfg->clockevent_rating,
+			      cfg->clockevent_rating != 0,
 			      cfg->clocksource_rating);
 	if (ret) {
 		dev_err(&cmt->pdev->dev, "ch%u: registration failed\n",
-- 
1.7.9.5

