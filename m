Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab3GVSKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:10:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:41817 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819Ab3GVSKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:10:19 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 07/16] usb: musb: replace ifndef with ifdef for CONFIG_MUSB_PIO_ONLY
Date: Mon, 22 Jul 2013 20:09:58 +0200
Message-Id: <1374516607-2705-8-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ifdef reads somehow better than an ifndef

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_dma.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/musb_dma.h b/drivers/usb/musb/musb_dma.h
index 1b6b827..8919ce2 100644
--- a/drivers/usb/musb/musb_dma.h
+++ b/drivers/usb/musb/musb_dma.h
@@ -62,10 +62,10 @@ struct musb_hw_ep;
 
 #define	DMA_ADDR_INVALID	(~(dma_addr_t)0)
 
-#ifndef CONFIG_MUSB_PIO_ONLY
-#define	is_dma_capable()	(1)
-#else
+#ifdef CONFIG_MUSB_PIO_ONLY
 #define	is_dma_capable()	(0)
+#else
+#define	is_dma_capable()	(1)
 #endif
 
 #ifdef CONFIG_USB_TI_CPPI_DMA
-- 
1.8.3.2

