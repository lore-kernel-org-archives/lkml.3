Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaCWPKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:10:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:58116 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaCWPKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:10:07 -0400
Message-Id: <20140323150753.325835408@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        atm <linux-atm-general@lists.sourceforge.net>,
        netdev <netdev@vger.kernel.org>
Subject: [patch 07/16] atm: firestream: Use del_timer_sync() in teardown path
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline; filename=atm-firestream-use-del-timer-sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device is about to vanish. So we need to make sure that the timer
is completely stopped and the callback is not running on another CPU.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: atm <linux-atm-general@lists.sourceforge.net>
Cc: netdev <netdev@vger.kernel.org>
---
 drivers/atm/firestream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/drivers/atm/firestream.c
===================================================================
--- tip.orig/drivers/atm/firestream.c
+++ tip/drivers/atm/firestream.c
@@ -2000,7 +2000,7 @@ static void firestream_remove_one(struct
 
 		fs_dprintk (FS_DEBUG_CLEANUP, "Freeing irq%d.\n", dev->irq);
 		free_irq (dev->irq, dev);
-		del_timer (&dev->timer);
+		del_timer_sync (&dev->timer);
 
 		atm_dev_deregister(dev->atm_dev);
 		free_queue (dev, &dev->hp_txq);


