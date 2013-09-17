Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3IQSxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:53:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:54493 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3IQSxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:53:09 -0400
Message-Id: <20130917183628.646285522@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 17 Sep 2013 18:53:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 2/6] h8300: Use schedule_preempt_irq
References: <20130917082838.218329307@infradead.org>
 <20130917182350.449685712@linutronix.de>
Content-Disposition: inline; filename=h8300-use-schedule-preempt-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the proper function instead of fiddling with PREEMPT_ACTIVE and
interrupt enable/disable in the low level code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>

---
 arch/h8300/kernel/entry.S |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6/arch/h8300/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/entry.S
+++ linux-2.6/arch/h8300/kernel/entry.S
@@ -316,13 +316,9 @@ need_resched:
 	beq	restore_all:8
 	mov.b	@(LCCR+1:16,sp),r0l	/* Interrupt Enabled? */
 	bmi	restore_all:8
-	mov.l	#PREEMPT_ACTIVE,er0
-	mov.l	er0,@(TI_PRE_COUNT:16,er4)
-	andc	#0x7f,ccr
 	mov.l	sp,er0
 	jsr	@_set_esp0
-	jsr	@_schedule
-	orc	#0x80,ccr
+	jsr	@_preempt_schedule_irq
 	bra	need_resched:8
 #endif
 


