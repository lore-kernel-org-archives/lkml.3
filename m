Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab3JNUuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:50:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35310 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758489Ab3JNUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:50:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/3] clocksource: sun4i: remove IRQF_DISABLED
Date: Mon, 14 Oct 2013 21:07:48 +0200
Message-Id: <1381777668-32565-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381777668-32565-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1381777668-32565-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_DISABLED is a no-op nowadays, so we can safely remove it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 46008f9..2fb4695 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -133,7 +133,7 @@ static irqreturn_t sun4i_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction sun4i_timer_irq = {
 	.name = "sun4i_timer0",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags = IRQF_TIMER | IRQF_IRQPOLL,
 	.handler = sun4i_timer_interrupt,
 	.dev_id = &sun4i_clockevent,
 };
-- 
1.8.4

