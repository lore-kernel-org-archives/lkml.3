Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaEWKdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:33:05 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49203 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaEWKc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:56 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 64/71] clocksource: dw_apb_timer_of: Do not trace read_sched_clock
Date: Fri, 23 May 2014 12:31:44 +0200
Message-Id: <1400841111-6683-64-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Wei <Wei.Yang@windriver.com>

We do not need to trace read_sched_clock function,
so add notrace attribute for this function.

Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/dw_apb_timer_of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 2a2ea27..d305fb0 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -106,7 +106,7 @@ static void __init add_clocksource(struct device_node *source_timer)
 	sched_rate = rate;
 }
 
-static u64 read_sched_clock(void)
+static u64 notrace read_sched_clock(void)
 {
 	return ~__raw_readl(sched_io_base);
 }
-- 
1.7.9.5

