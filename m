Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaCWPJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:09:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:58103 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaCWPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:24 -0400
Message-Id: <20140323150754.381232240@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        input <linux-input@vger.kernel.org>
Subject: [patch 16/16] input: serio: hp_sdc: Use del_timer_sync() in exit path
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline;
 filename=input-serio-hp_sdc-use-del_timer_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that no callback is running before we teardown the module.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: input <linux-input@vger.kernel.org>
---
 drivers/input/serio/hp_sdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/drivers/input/serio/hp_sdc.c
===================================================================
--- tip.orig/drivers/input/serio/hp_sdc.c
+++ tip/drivers/input/serio/hp_sdc.c
@@ -984,7 +984,7 @@ static void hp_sdc_exit(void)
 	free_irq(hp_sdc.irq, &hp_sdc);
 	write_unlock_irq(&hp_sdc.lock);
 
-	del_timer(&hp_sdc.kicker);
+	del_timer_sync(&hp_sdc.kicker);
 
 	tasklet_kill(&hp_sdc.task);
 


