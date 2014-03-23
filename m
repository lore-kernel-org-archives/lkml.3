Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaCWPMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:12:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:58036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaCWPJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:20 -0400
Message-Id: <20140323150753.786674651@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: [patch 11/16] block: xsysace; Use del_timer_sync() in exit path
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline;
 filename=block-xsysace-teardown-timer-on-exit.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure which contains the timer is about to be freed. Make
sure no callback is running.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/block/xsysace.c |    2 ++
 1 file changed, 2 insertions(+)

Index: tip/drivers/block/xsysace.c
===================================================================
--- tip.orig/drivers/block/xsysace.c
+++ tip/drivers/block/xsysace.c
@@ -1088,6 +1088,8 @@ static void ace_teardown(struct ace_devi
 	if (ace->irq)
 		free_irq(ace->irq, ace);
 
+	del_timer_sync(&ace->stall_timer);
+
 	iounmap(ace->baseaddr);
 }
 


