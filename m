Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3EaVpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:45:04 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:35864 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3EaVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:44:58 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mfd: twl4030: allow IRQ wake enable to succeed on subchip IRQs
Date: Fri, 31 May 2013 14:44:54 -0700
Message-Id: <1370036694-26210-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq IRQ wake method will default to failure if the irq_chip
does not provide a set_wake method.  However, for TWL4030 sub-chip
IRQs, we want the wake enable to succeed even though we don't provide
a set_wake method.  This allows sub-chip IRQs to still be flagged as
wakeup capable, and allow them to wakeup from suspend (or abort
suspend if they fire during suspend.)

To fix, use the IRQCHIP_SKIP_SET_WAKE flag in the irq_chip.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/mfd/twl4030-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index a5f9888..3fa7df2 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -573,6 +573,7 @@ static struct irq_chip twl4030_sih_irq_chip = {
 	.irq_set_type	= twl4030_sih_set_type,
 	.irq_bus_lock	= twl4030_sih_bus_lock,
 	.irq_bus_sync_unlock = twl4030_sih_bus_sync_unlock,
+	.flags		= IRQCHIP_SKIP_SET_WAKE,
 };
 
 /*----------------------------------------------------------------------*/
-- 
1.8.2

