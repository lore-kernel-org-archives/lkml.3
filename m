Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3GVSKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:10:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:41797 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab3GVSKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:10:15 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/16] usb: musb: dsps: init / shutdown the phy
Date: Mon, 22 Jul 2013 20:09:52 +0200
Message-Id: <1374516607-2705-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the init / shutdown function of the phy moves out of dsps into the
phy driver, then dsps needs to call the callbacks of the phy driver to
ensure that this happens.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_dsps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 5233804..603ea74 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -428,6 +428,8 @@ static int dsps_musb_init(struct musb *musb)
 		goto err0;
 	}
 
+	usb_phy_init(musb->xceiv);
+
 	setup_timer(&glue->timer[pdev->id], otg_timer, (unsigned long) musb);
 
 	/* Reset the musb */
@@ -463,6 +465,7 @@ static int dsps_musb_exit(struct musb *musb)
 
 	/* Shutdown the on-chip PHY and its PLL. */
 	musb_dsps_phy_control(glue, pdev->id, 0);
+	usb_phy_shutdown(musb->xceiv);
 
 	/* NOP driver needs change if supporting dual instance */
 	usb_put_phy(musb->xceiv);
-- 
1.8.3.2

