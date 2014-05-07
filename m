Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbaEGPqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:46:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:48657 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910AbaEGPoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:05 -0400
Message-Id: <20140507154339.609149081@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 26/32] s390: Remove pointless arch_show_interrupts()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline;
 filename=s390-remove-pointless-arch-show-interrupts.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S390 is not using the generic show interrupts implementation so the
extra arch_show_interrupts() is just useless.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
---
 arch/s390/kernel/irq.c |    5 -----
 1 file changed, 5 deletions(-)

Index: tip/arch/s390/kernel/irq.c
===================================================================
--- tip.orig/arch/s390/kernel/irq.c
+++ tip/arch/s390/kernel/irq.c
@@ -151,11 +151,6 @@ out:
 	return 0;
 }
 
-int arch_show_interrupts(struct seq_file *p, int prec)
-{
-	return 0;
-}
-
 /*
  * Switch to the asynchronous interrupt stack for softirq execution.
  */


