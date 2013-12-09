Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008Ab3LIJgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:36:10 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34067 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750805Ab3LIJgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:36:05 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de, swarren@wwwdotorg.org,
        thierry.reding@gmail.com
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] clocksource: tegra: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 10:35:45 +0100
Message-Id: <1386581745-4559-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381639360-6920-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381639360-6920-1-git-send-email-michael.opdenacker@free-electrons.com>
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
index 642849256d82..d1869f02051c 100644
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
1.8.3.2

