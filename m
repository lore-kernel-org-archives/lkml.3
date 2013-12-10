Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3LJTQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:16:23 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:50973 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab3LJTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:16:20 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/6] clocksource: dw_apb_timer_of: Fix read_sched_clock
Date: Tue, 10 Dec 2013 20:16:11 +0100
Message-Id: <1386702972-25565-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
References: <52A767CB.3010501@linaro.org>
 <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@altera.com>

The read_sched_clock should return the ~value because the clock is a
countdown implementation. read_sched_clock() should be the same as
 __apbt_read_clocksource().

Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/dw_apb_timer_of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 45ba8ae..b29d7cd 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -108,7 +108,7 @@ static void __init add_clocksource(struct device_node *source_timer)
 
 static u64 read_sched_clock(void)
 {
-	return __raw_readl(sched_io_base);
+	return ~__raw_readl(sched_io_base);
 }
 
 static const struct of_device_id sptimer_ids[] __initconst = {
-- 
1.7.9.5

