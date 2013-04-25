Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab3DYUbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:31:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:45962 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996Ab3DYUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:44 -0400
Message-Id: <20130425143435.558006195@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>, Jamie Iles <jamie@jamieiles.com>
Subject: [patch 01/15] clocksource: apb_timer: Remove unsused function
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-apb-timer-remove-unsused-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>
---
 drivers/clocksource/dw_apb_timer.c |   12 ------------
 include/linux/dw_apb_timer.h       |    1 -
 2 files changed, 13 deletions(-)

Index: tip/drivers/clocksource/dw_apb_timer.c
===================================================================
--- tip.orig/drivers/clocksource/dw_apb_timer.c
+++ tip/drivers/clocksource/dw_apb_timer.c
@@ -387,15 +387,3 @@ cycle_t dw_apb_clocksource_read(struct d
 {
 	return (cycle_t)~apbt_readl(&dw_cs->timer, APBTMR_N_CURRENT_VALUE);
 }
-
-/**
- * dw_apb_clocksource_unregister() - unregister and free a clocksource.
- *
- * @dw_cs:	The clocksource to unregister/free.
- */
-void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs)
-{
-	clocksource_unregister(&dw_cs->cs);
-
-	kfree(dw_cs);
-}
Index: tip/include/linux/dw_apb_timer.h
===================================================================
--- tip.orig/include/linux/dw_apb_timer.h
+++ tip/include/linux/dw_apb_timer.h
@@ -51,7 +51,6 @@ dw_apb_clocksource_init(unsigned rating,
 void dw_apb_clocksource_register(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
 cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs);
-void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs);
 
 extern void dw_apb_timer_init(void);
 #endif /* __DW_APB_TIMER_H__ */


