Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3LJTQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:16:54 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52842 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3LJTQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:16:22 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 6/6] clocksource: dw_apb_timer_of: Fix support for dts binding "snps,dw-apb-timer"
Date: Tue, 10 Dec 2013 20:16:12 +0100
Message-Id: <1386702972-25565-6-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
References: <52A767CB.3010501@linaro.org>
 <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@altera.com>

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
index b29d7cd..2a2ea27 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -113,7 +113,6 @@ static u64 read_sched_clock(void)
 
 static const struct of_device_id sptimer_ids[] __initconst = {
 	{ .compatible = "picochip,pc3x2-rtc" },
-	{ .compatible = "snps,dw-apb-timer-sp" },
 	{ /* Sentinel */ },
 };
 
@@ -151,4 +150,6 @@ static void __init dw_apb_timer_init(struct device_node *timer)
 	num_called++;
 }
 CLOCKSOURCE_OF_DECLARE(pc3x2_timer, "picochip,pc3x2-timer", dw_apb_timer_init);
-CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_osc, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_sp, "snps,dw-apb-timer-sp", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer", dw_apb_timer_init);
-- 
1.7.9.5

