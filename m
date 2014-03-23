Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaCWPNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:13:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:57995 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaCWPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:18 -0400
Message-Id: <20140323150753.078968144@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [patch 05/16] thermal: powerclamp: Add missing
 destroy_timer_on_stack()
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline;
 filename=thermal-powerclamp-add-missing-destroy_timer_on_stack.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we leak a tracking object when DEBOG_OBJECTS is enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/intel_powerclamp.c |    1 +
 1 file changed, 1 insertion(+)

Index: tip/drivers/thermal/intel_powerclamp.c
===================================================================
--- tip.orig/drivers/thermal/intel_powerclamp.c
+++ tip/drivers/thermal/intel_powerclamp.c
@@ -455,6 +455,7 @@ static int clamp_thread(void *arg)
 		preempt_enable();
 	}
 	del_timer_sync(&wakeup_timer);
+	destroy_timer_on_stack(&wakeup_timer);
 	clear_bit(cpunr, cpu_clamping_mask);
 
 	return 0;


