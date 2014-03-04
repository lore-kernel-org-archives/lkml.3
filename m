Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbaCDUEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbaCDUE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.13 147/172] irqchip: orion: Fix getting generic chip pointer.
Date: Tue,  4 Mar 2014 12:03:51 -0800
Message-Id: <20140304200304.431593795@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit d86e9af6336c0ad586a5dbd70064253d40bbb5ff upstream.

Enabling SPARSE_IRQ shows up a bug in the irq-orion bridge interrupt
handler. The bridge interrupt is implemented using a single generic
chip. Thus the parameter passed to irq_get_domain_generic_chip()
should always be zero.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Fixes: 9dbd90f17e4f ("irqchip: Add support for Marvell Orion SoCs")
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-orion.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -111,7 +111,8 @@ IRQCHIP_DECLARE(orion_intc, "marvell,ori
 static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct irq_domain *d = irq_get_handler_data(irq);
-	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, irq);
+
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, 0);
 	u32 stat = readl_relaxed(gc->reg_base + ORION_BRIDGE_IRQ_CAUSE) &
 		   gc->mask_cache;
 


