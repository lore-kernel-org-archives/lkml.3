Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3GVSLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:11:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:41841 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab3GVSK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:10:59 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after removal
Date: Mon, 22 Jul 2013 20:10:05 +0200
Message-Id: <1374516607-2705-15-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the MUSB_DEVCTL_SESSION back after it has been removed.
If it is missing then the host session is not recognized. This bit is
added initially added in musb_start() and removed after the first device
disconnect.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_dsps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 2e45723..1a2b163 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -186,6 +186,9 @@ static void otg_timer(unsigned long _musb)
 		dsps_writeb(musb->mregs, MUSB_DEVCTL, devctl);
 
 		devctl = dsps_readb(musb->mregs, MUSB_DEVCTL);
+		devctl |= MUSB_DEVCTL_SESSION;
+		dsps_writeb(musb->mregs, MUSB_DEVCTL, devctl);
+
 		if (devctl & MUSB_DEVCTL_BDEVICE) {
 			musb->xceiv->state = OTG_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
-- 
1.8.3.2

