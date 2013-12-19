Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3LSWat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:30:49 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:56000 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3LSWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:30:16 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, dinguyen@altera.com,
        baruch@tkos.co.il, tglx@linutronix.de
Subject: [PATCH-3.12.y 2/2] clocksource: dw_apb_timer_of: Fix support for dts binding "snps,dw-apb-timer"
Date: Thu, 19 Dec 2013 23:30:14 +0100
Message-Id: <1387492214-27911-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387492214-27911-1-git-send-email-daniel.lezcano@linaro.org>
References: <1387492214-27911-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@altera.com>

Upstream commit 9ab4727

In commit 620f5e1cbf (dts: Rename DW APB timer compatible strings), both
"snps,dw-apb-timer-sp" and "snps,dw-apb-timer-osc" were deprecated in place
of "snps,dw-apb-timer". But the driver also needs to be udpated in order to
support this new binding "snps,dw-apb-timer".

Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/dw_apb_timer_of.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 33fd4ff..b386be6 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -113,7 +113,6 @@ static u32 read_sched_clock(void)
 
 static const struct of_device_id sptimer_ids[] __initconst = {
 	{ .compatible = "picochip,pc3x2-rtc" },
-	{ .compatible = "snps,dw-apb-timer-sp" },
 	{ /* Sentinel */ },
 };
 
@@ -153,4 +152,6 @@ static void __init dw_apb_timer_init(struct device_node *timer)
 	num_called++;
 }
 CLOCKSOURCE_OF_DECLARE(pc3x2_timer, "picochip,pc3x2-timer", dw_apb_timer_init);
-CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_osc, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_sp, "snps,dw-apb-timer-sp", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer", dw_apb_timer_init);
-- 
1.7.9.5

