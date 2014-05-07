Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbaEGPtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:49:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:48586 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbaEGPoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:00 -0400
Message-Id: <20140507154337.643399187@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 18/32] tile: serial: Use irq_alloc/free_hwirq
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=tile-serial-use-alloc-free-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Just convert to the new interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/tty/serial/tilegx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: tip/drivers/tty/serial/tilegx.c
===================================================================
--- tip.orig/drivers/tty/serial/tilegx.c
+++ tip/drivers/tty/serial/tilegx.c
@@ -359,8 +359,8 @@ static int tilegx_startup(struct uart_po
 		}
 
 		/* Create our IRQs. */
-		port->irq = create_irq();
-		if (port->irq < 0)
+		port->irq = irq_alloc_hwirq(-1);
+		if (!port->irq)
 			goto err_uart_dest;
 		tile_irq_activate(port->irq, TILE_IRQ_PERCPU);
 
@@ -395,7 +395,7 @@ static int tilegx_startup(struct uart_po
 err_free_irq:
 	free_irq(port->irq, port);
 err_dest_irq:
-	destroy_irq(port->irq);
+	irq_free_hwirq(port->irq);
 err_uart_dest:
 	gxio_uart_destroy(context);
 	ret = -ENXIO;
@@ -435,7 +435,7 @@ static void tilegx_shutdown(struct uart_
 
 	if (port->irq > 0) {
 		free_irq(port->irq, port);
-		destroy_irq(port->irq);
+		irq_free_hwirq(port->irq);
 		port->irq = 0;
 	}
 


