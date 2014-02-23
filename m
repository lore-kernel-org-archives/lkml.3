Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaBWVqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:46:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:52249 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaBWVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:07 -0500
Message-Id: <20140223212737.751487689@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        mn10300 <linux-am33-list@redhat.com>
Subject: [patch 14/26] mn10300: Use the core irq stats function
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=mn10300-use-core-irq-stats-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: mn10300 <linux-am33-list@redhat.com>
---
 arch/mn10300/kernel/mn10300-watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/arch/mn10300/kernel/mn10300-watchdog.c
===================================================================
--- tip.orig/arch/mn10300/kernel/mn10300-watchdog.c
+++ tip/arch/mn10300/kernel/mn10300-watchdog.c
@@ -142,7 +142,7 @@ void watchdog_interrupt(struct pt_regs *
 	NMICR = NMICR_WDIF;
 
 	nmi_count(smp_processor_id())++;
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 
 	for_each_online_cpu(cpu) {
 


