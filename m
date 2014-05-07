Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbaEGPuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:50:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:48580 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbaEGPn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:59 -0400
Message-Id: <20140507154337.410843062@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 17/32] tile: net: Use irq_alloc/free_hwirq
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=tile-net-use-alloc-free-irq.patch
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
 drivers/net/ethernet/tile/tilegx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: tip/drivers/net/ethernet/tile/tilegx.c
===================================================================
--- tip.orig/drivers/net/ethernet/tile/tilegx.c
+++ tip/drivers/net/ethernet/tile/tilegx.c
@@ -1208,8 +1208,8 @@ static int tile_net_setup_interrupts(str
 
 	irq = md->ingress_irq;
 	if (irq < 0) {
-		irq = create_irq();
-		if (irq < 0) {
+		irq = irq_alloc_hwirq(-1);
+		if (!irq) {
 			netdev_err(dev,
 				   "create_irq failed: mpipe[%d] %d\n",
 				   instance, irq);
@@ -1223,7 +1223,7 @@ static int tile_net_setup_interrupts(str
 		if (rc != 0) {
 			netdev_err(dev, "request_irq failed: mpipe[%d] %d\n",
 				   instance, rc);
-			destroy_irq(irq);
+			irq_free_hwirq(irq);
 			return rc;
 		}
 		md->ingress_irq = irq;


