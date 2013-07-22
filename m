Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab3GVSK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:10:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:41826 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab3GVSKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:10:21 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 09/16] usb: musb: provide empty dma_controller_create() in PIO mode
Date: Mon, 22 Jul 2013 20:10:00 +0200
Message-Id: <1374516607-2705-10-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dma_controller_create() returning NULL so a few ifdefs can
dropped.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_dma.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/musb/musb_dma.h b/drivers/usb/musb/musb_dma.h
index 3603711..c8e67fd 100644
--- a/drivers/usb/musb/musb_dma.h
+++ b/drivers/usb/musb/musb_dma.h
@@ -175,9 +175,20 @@ struct dma_controller {
 /* called after channel_program(), may indicate a fault */
 extern void musb_dma_completion(struct musb *musb, u8 epnum, u8 transmit);
 
+#ifdef CONFIG_MUSB_PIO_ONLY
+static inline struct dma_controller *dma_controller_create(struct musb *m,
+		void __iomem *io)
+{
+	return NULL;
+}
+
+static inline void dma_controller_destroy(struct dma_controller *d) { }
+
+#else
 
 extern struct dma_controller *dma_controller_create(struct musb *, void __iomem *);
 
 extern void dma_controller_destroy(struct dma_controller *);
+#endif
 
 #endif	/* __MUSB_DMA_H__ */
-- 
1.8.3.2

