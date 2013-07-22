Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab3GVSMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:12:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:41859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3GVSMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:12:03 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 11/16] usb: musb: core: call dma_controller_destroy() in the err path
Date: Mon, 22 Jul 2013 20:10:02 +0200
Message-Id: <1374516607-2705-12-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cleanup in the error is missing the dma controller. The structure is
allocated at runtime and ux500 allocates even a little more than just
this struct. So cleanup!

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index b33bed5..9b774e7 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1933,6 +1933,8 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	musb_gadget_cleanup(musb);
 
 fail3:
+	if (musb->dma_controller)
+		dma_controller_destroy(musb->dma_controller);
 	pm_runtime_put_sync(musb->controller);
 
 fail2:
-- 
1.8.3.2

