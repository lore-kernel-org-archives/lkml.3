Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3E0LwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:52:25 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:46108 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab3E0LwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:52:23 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        <stable@vger.kernel.org>
Subject: [PATCH] clocksource: dw_apb: fix error check
Date: Mon, 27 May 2013 14:51:35 +0300
Message-Id: <90d7cc35674bf04806531eb2e9836fdc382868d9.1369655478.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_of_parse_and_map() returns 0 on error, while the code checks for NO_IRQ.
This breaks on platforms that have NO_IRQ != 0.

Cc: <stable@vger.kernel.org>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/clocksource/dw_apb_timer_of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 9fdb4d3..843d43b 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -47,7 +47,7 @@ static void add_clockevent(struct device_node *event_timer)
 	u32 irq, rate;
 
 	irq = irq_of_parse_and_map(event_timer, 0);
-	if (irq == NO_IRQ)
+	if (irq == 0)
 		panic("No IRQ for clock event timer");
 
 	timer_get_base_and_rate(event_timer, &iobase, &rate);
-- 
1.7.10.4

