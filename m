Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3CBKKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 05:10:21 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57071 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab3CBKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 05:10:18 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: john.stultz@linaro.org, tglx@linutronix.de
Cc: viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org,
        linus.walleij@stericsson.com
Subject: [PATCH 3/4][V2] ARM: nomadik: add dynamic irq flag to the timer
Date: Sat,  2 Mar 2013 11:10:12 +0100
Message-Id: <1362219013-18173-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org>
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the dynamic irq affinity feature to the timer clock device.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Acked-by: Rickard Andersson <rickard.andersson@stericsson.com>
---
 drivers/clocksource/nomadik-mtu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index 7cbcaa0..73dc540 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -136,7 +136,8 @@ static void nmdk_clkevt_mode(enum clock_event_mode mode,
 
 static struct clock_event_device nmdk_clkevt = {
 	.name		= "mtu_1",
-	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
+	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC |
+	                  CLOCK_EVT_FEAT_DYNIRQ,
 	.rating		= 200,
 	.set_mode	= nmdk_clkevt_mode,
 	.set_next_event	= nmdk_clkevt_next,
-- 
1.7.9.5

