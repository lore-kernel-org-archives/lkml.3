Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851AbaEGPu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:50:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:48573 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaEGPn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:59 -0400
Message-Id: <20140507154337.177939962@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 16/32] tile: usb: Use irq_alloc/free_hwirq
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=tile-usb-use-alloc-free-irq.patch
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
 drivers/usb/host/ehci-tilegx.c |    8 ++++----
 drivers/usb/host/ohci-tilegx.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: tip/drivers/usb/host/ehci-tilegx.c
===================================================================
--- tip.orig/drivers/usb/host/ehci-tilegx.c
+++ tip/drivers/usb/host/ehci-tilegx.c
@@ -142,8 +142,8 @@ static int ehci_hcd_tilegx_drv_probe(str
 	ehci->hcs_params = readl(&ehci->caps->hcs_params);
 
 	/* Create our IRQs and register them. */
-	pdata->irq = create_irq();
-	if (pdata->irq < 0) {
+	pdata->irq = irq_alloc_hwirq(-1);
+	if (!pdata->irq) {
 		ret = -ENXIO;
 		goto err_no_irq;
 	}
@@ -175,7 +175,7 @@ static int ehci_hcd_tilegx_drv_probe(str
 	}
 
 err_have_irq:
-	destroy_irq(pdata->irq);
+	irq_free_hwirq(pdata->irq);
 err_no_irq:
 	tilegx_stop_ehc();
 	usb_put_hcd(hcd);
@@ -193,7 +193,7 @@ static int ehci_hcd_tilegx_drv_remove(st
 	usb_put_hcd(hcd);
 	tilegx_stop_ehc();
 	gxio_usb_host_destroy(&pdata->usb_ctx);
-	destroy_irq(pdata->irq);
+	irq_free_hwirq(pdata->irq);
 
 	return 0;
 }
Index: tip/drivers/usb/host/ohci-tilegx.c
===================================================================
--- tip.orig/drivers/usb/host/ohci-tilegx.c
+++ tip/drivers/usb/host/ohci-tilegx.c
@@ -129,8 +129,8 @@ static int ohci_hcd_tilegx_drv_probe(str
 	tilegx_start_ohc();
 
 	/* Create our IRQs and register them. */
-	pdata->irq = create_irq();
-	if (pdata->irq < 0) {
+	pdata->irq = irq_alloc_hwirq(-1);
+	if (!pdata->irq) {
 		ret = -ENXIO;
 		goto err_no_irq;
 	}
@@ -164,7 +164,7 @@ static int ohci_hcd_tilegx_drv_probe(str
 	}
 
 err_have_irq:
-	destroy_irq(pdata->irq);
+	irq_free_hwirq(pdata->irq);
 err_no_irq:
 	tilegx_stop_ohc();
 	usb_put_hcd(hcd);
@@ -182,7 +182,7 @@ static int ohci_hcd_tilegx_drv_remove(st
 	usb_put_hcd(hcd);
 	tilegx_stop_ohc();
 	gxio_usb_host_destroy(&pdata->usb_ctx);
-	destroy_irq(pdata->irq);
+	irq_free_hwirq(pdata->irq);
 
 	return 0;
 }


