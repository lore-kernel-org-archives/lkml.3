Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3FNQmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:42:51 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46970 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3FNQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:41:05 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 3/7] mfd: twl4030-irq: use irq_get_trigger_type() to get IRQ flags
Date: Fri, 14 Jun 2013 18:40:45 +0200
Message-Id: <1371228049-27080-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use irq_get_trigger_type() to get the IRQ trigger type flags
instead calling irqd_get_trigger_type(irq_get_irq_data(irq))

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mfd/twl4030-irq.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index a5f9888..9d2d1ba 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -537,16 +537,13 @@ static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 		/* Modify only the bits we know must change */
 		while (edge_change) {
 			int		i = fls(edge_change) - 1;
-			struct irq_data	*idata;
 			int		byte = i >> 2;
 			int		off = (i & 0x3) * 2;
 			unsigned int	type;
 
-			idata = irq_get_irq_data(i + agent->irq_base);
-
 			bytes[byte] &= ~(0x03 << off);
 
-			type = irqd_get_trigger_type(idata);
+			type = irq_get_trigger_type(i + agent->irq_base);
 			if (type & IRQ_TYPE_EDGE_RISING)
 				bytes[byte] |= BIT(off + 1);
 			if (type & IRQ_TYPE_EDGE_FALLING)
-- 
1.7.7.6

