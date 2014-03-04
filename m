Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaCDQmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:42:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCDQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:42:03 -0500
Date: Tue, 4 Mar 2014 08:41:25 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-310ff2c87e72208e4f04f33687abe9d208ffefe3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        inux-mips@linux-mips.org, ralf@linux-mips.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, inux-mips@linux-mips.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20140223212737.517340416@linutronix.de>
References: <20140223212737.517340416@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] mips: Use the core irq stats function
Git-Commit-ID: 310ff2c87e72208e4f04f33687abe9d208ffefe3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  310ff2c87e72208e4f04f33687abe9d208ffefe3
Gitweb:     http://git.kernel.org/tip/310ff2c87e72208e4f04f33687abe9d208ffefe3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:14 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:53 +0100

mips: Use the core irq stats function

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: mips <inux-mips@linux-mips.org>
Link: http://lkml.kernel.org/r/20140223212737.517340416@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/kernel/smtc.c        | 2 +-
 arch/mips/sgi-ip22/ip22-int.c  | 2 +-
 arch/mips/sgi-ip22/ip22-time.c | 2 +-
 arch/mips/sibyte/bcm1480/smp.c | 2 +-
 arch/mips/sibyte/sb1250/smp.c  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index dfc1b91..c1681d6 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -1007,7 +1007,7 @@ static void __irq_entry smtc_clock_tick_interrupt(void)
 	int irq = MIPS_CPU_IRQ_BASE + 1;
 
 	irq_enter();
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	cd = &per_cpu(mips_clockevent_device, cpu);
 	cd->event_handler(cd);
 	irq_exit();
diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index 3db64d5..58b40ae 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -148,7 +148,7 @@ static void __irq_entry indy_buserror_irq(void)
 	int irq = SGI_BUSERR_IRQ;
 
 	irq_enter();
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	ip22_be_interrupt(irq);
 	irq_exit();
 }
diff --git a/arch/mips/sgi-ip22/ip22-time.c b/arch/mips/sgi-ip22/ip22-time.c
index 6071924..045aa89 100644
--- a/arch/mips/sgi-ip22/ip22-time.c
+++ b/arch/mips/sgi-ip22/ip22-time.c
@@ -123,7 +123,7 @@ void __irq_entry indy_8254timer_irq(void)
 	char c;
 
 	irq_enter();
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	printk(KERN_ALERT "Oops, got 8254 interrupt.\n");
 	ArcRead(0, &c, 1, &cnt);
 	ArcEnterInteractiveMode();
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index 54e2c4d..70d9182 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -182,7 +182,7 @@ void bcm1480_mailbox_interrupt(void)
 	int irq = K_BCM1480_INT_MBOX_0_0;
 	unsigned int action;
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (__raw_readq(mailbox_0_regs[cpu]) >> 48) & 0xffff;
 
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index d7b942d..db97611 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -170,7 +170,7 @@ void sb1250_mailbox_interrupt(void)
 	int irq = K_INT_MBOX_0;
 	unsigned int action;
 
-	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	kstat_incr_irq_this_cpu(irq);
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (____raw_readq(mailbox_regs[cpu]) >> 48) & 0xffff;
 
