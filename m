Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3LSWaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:30:18 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:58242 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab3LSWaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:30:14 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, dinguyen@altera.com,
        baruch@tkos.co.il, tglx@linutronix.de
Subject: [PATCH-3.12.y 1/2] clocksource: dw_apb_timer_of: Fix read_sched_clock
Date: Thu, 19 Dec 2013 23:30:13 +0100
Message-Id: <1387492214-27911-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@altera.com>

Upstream commit 85dc6ee

The read_sched_clock should return the ~value because the clock is a
countdown implementation. read_sched_clock() should be the same as
 __apbt_read_clocksource().

Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/dw_apb_timer_of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 4cbae4f..33fd4ff 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -108,7 +108,7 @@ static void add_clocksource(struct device_node *source_timer)
 
 static u32 read_sched_clock(void)
 {
-	return __raw_readl(sched_io_base);
+	return ~__raw_readl(sched_io_base);
 }
 
 static const struct of_device_id sptimer_ids[] __initconst = {
-- 
1.7.9.5

