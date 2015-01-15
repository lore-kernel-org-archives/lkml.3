Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbbAOByc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:54:32 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44515 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbbAOBya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:54:30 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH RESEND] pxa_timer: fix session missmatch warning
Date: Thu, 15 Jan 2015 04:54:20 +0300
Message-Id: <1421286860-23296-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:

WARNING: drivers/clocksource/built-in.o(.text.unlikely+0x70): Section mismatch in reference from the function pxa_timer_common_init() to the function .init.text:clocksource_mmio_init()
The function pxa_timer_common_init() references
the function __init clocksource_mmio_init().
This is often because pxa_timer_common_init lacks a __init
annotation or the annotation of clocksource_mmio_init is wrong.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/clocksource/pxa_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/pxa_timer.c b/drivers/clocksource/pxa_timer.c
index 941f3f3..d9438af 100644
--- a/drivers/clocksource/pxa_timer.c
+++ b/drivers/clocksource/pxa_timer.c
@@ -163,7 +163,7 @@ static struct irqaction pxa_ost0_irq = {
 	.dev_id		= &ckevt_pxa_osmr0,
 };
 
-static void pxa_timer_common_init(int irq, unsigned long clock_tick_rate)
+static void __init pxa_timer_common_init(int irq, unsigned long clock_tick_rate)
 {
 	timer_writel(0, OIER);
 	timer_writel(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
-- 
2.1.4

