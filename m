Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaEWKlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:41:37 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:44069 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaEWKcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:36 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 48/71] clocksource: sh_mtu2: Hardcode MTU2 clock event rating to 200
Date: Fri, 23 May 2014 12:31:28 +0200
Message-Id: <1400841111-6683-48-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

All boards use clock event ratings of 200 for the MTU2, hardcode it in
the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/clocksource/sh_mtu2.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 702ce60..14cc7b6 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -323,14 +323,14 @@ static void sh_mtu2_clock_event_resume(struct clock_event_device *ced)
 }
 
 static void sh_mtu2_register_clockevent(struct sh_mtu2_channel *ch,
-					const char *name, unsigned long rating)
+					const char *name)
 {
 	struct clock_event_device *ced = &ch->ced;
 	int ret;
 
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
-	ced->rating = rating;
+	ced->rating = 200;
 	ced->cpumask = cpu_possible_mask;
 	ced->set_mode = sh_mtu2_clock_event_mode;
 	ced->suspend = sh_mtu2_clock_event_suspend;
@@ -351,10 +351,10 @@ static void sh_mtu2_register_clockevent(struct sh_mtu2_channel *ch,
 }
 
 static int sh_mtu2_register(struct sh_mtu2_channel *ch, const char *name,
-			    unsigned long clockevent_rating)
+			    bool clockevent)
 {
-	if (clockevent_rating)
-		sh_mtu2_register_clockevent(ch, name, clockevent_rating);
+	if (clockevent)
+		sh_mtu2_register_clockevent(ch, name);
 
 	return 0;
 }
@@ -375,7 +375,7 @@ static int sh_mtu2_setup_channel(struct sh_mtu2_channel *ch,
 	}
 
 	return sh_mtu2_register(ch, dev_name(&mtu->pdev->dev),
-				cfg->clockevent_rating);
+				cfg->clockevent_rating != 0);
 }
 
 static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
-- 
1.7.9.5

