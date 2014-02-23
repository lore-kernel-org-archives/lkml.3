Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaBWVpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:45:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:52268 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaBWVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:09 -0500
Message-Id: <20140223212737.869264085@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen <xen-devel@lists.xenproject.org>, x86 <x86@kernel.org>
Subject: [patch 15/26] x86: xen: Use the core irq stats function
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=x86-xen-use-core-irq-stats-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
Cc: x86 <x86@kernel.org>
---
 arch/x86/xen/spinlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/arch/x86/xen/spinlock.c
===================================================================
--- tip.orig/arch/x86/xen/spinlock.c
+++ tip/arch/x86/xen/spinlock.c
@@ -183,7 +183,7 @@ __visible void xen_lock_spinning(struct
 
 	local_irq_save(flags);
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 out:
 	cpumask_clear_cpu(cpu, &waiting_cpus);
 	w->lock = NULL;


