Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3JMEmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 00:42:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56062 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772Ab3JMEmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 00:42:43 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de, swarren@wwwdotorg.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] clocksource: tegra: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 06:42:40 +0200
Message-Id: <1381639360-6920-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/clocksource/tegra20_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index 9396170..58e0109 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -149,7 +149,7 @@ static irqreturn_t tegra_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction tegra_timer_irq = {
 	.name		= "timer0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_TRIGGER_HIGH,
+	.flags		= IRQF_TIMER | IRQF_TRIGGER_HIGH,
 	.handler	= tegra_timer_interrupt,
 	.dev_id		= &tegra_clockevent,
 };
-- 
1.8.1.2

