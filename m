Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbaEGPsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:48:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:48619 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbaEGPoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:02 -0400
Message-Id: <20140507154338.700598389@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [patch 22/32] genirq: Make create/destroy_irq() ia64 private
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline;
 filename=irq-make-create-destroy-irq-ia64-private.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more users outside of itanic. Confine it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/include/asm/irq.h |    3 +++
 include/linux/irq.h         |    4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: tip/arch/ia64/include/asm/irq.h
===================================================================
--- tip.orig/arch/ia64/include/asm/irq.h
+++ tip/arch/ia64/include/asm/irq.h
@@ -31,4 +31,7 @@ bool is_affinity_mask_valid(const struct
 
 #define is_affinity_mask_valid is_affinity_mask_valid
 
+int create_irq(void);
+void destroy_irq(unsigned int irq);
+
 #endif /* _ASM_IA64_IRQ_H */
Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -525,10 +525,6 @@ static inline void irq_set_percpu_devid_
 			     IRQ_NOPROBE | IRQ_PER_CPU_DEVID);
 }
 
-/* Handle dynamic irq creation and destruction */
-extern int create_irq(void);
-extern void destroy_irq(unsigned int irq);
-
 /*
  * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and
  * irq_free_desc instead.


