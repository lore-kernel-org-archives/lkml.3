Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082Ab3LIJjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:39:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34087 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761065Ab3LIJjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:39:02 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@prisktech.co.nz, daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] clocksource: vt8500: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 10:38:50 +0100
Message-Id: <1386581930-4618-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381639194-6861-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381639194-6861-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/clocksource/vt8500_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/vt8500_timer.c b/drivers/clocksource/vt8500_timer.c
index ad3c0e83a779..1098ed3b9b89 100644
--- a/drivers/clocksource/vt8500_timer.c
+++ b/drivers/clocksource/vt8500_timer.c
@@ -124,7 +124,7 @@ static irqreturn_t vt8500_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq = {
 	.name    = "vt8500_timer",
-	.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags   = IRQF_TIMER | IRQF_IRQPOLL,
 	.handler = vt8500_timer_interrupt,
 	.dev_id  = &clockevent,
 };
-- 
1.8.3.2

