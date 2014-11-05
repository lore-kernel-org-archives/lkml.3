Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaKEQjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:39:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaKEQjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:39:17 -0500
Date: Wed, 5 Nov 2014 08:37:43 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-4451646b745acafc89a88a17f09c6d0be4213161@git.kernel.org>
Cc: jiang.liu@linux.intel.com, tglx@linutronix.de, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, rdunlap@infradead.org,
        konrad.wilk@oracle.com, bp@alien8.de, bhelgaas@google.com,
        yinghai@kernel.org, tony.luck@intel.com, hpa@zytor.com,
        joro@8bytes.org, rjw@rjwysocki.net, gregkh@linuxfoundation.org
Reply-To: tglx@linutronix.de, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, bp@alien8.de, rdunlap@infradead.org,
        konrad.wilk@oracle.com, hpa@zytor.com, tony.luck@intel.com,
        yinghai@kernel.org, bhelgaas@google.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, rjw@rjwysocki.net
In-Reply-To: <1414397531-28254-11-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-11-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Replace printk(KERN_LVL) with pr_lvl()
  utilities
Git-Commit-ID: 4451646b745acafc89a88a17f09c6d0be4213161
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

Commit-ID:  4451646b745acafc89a88a17f09c6d0be4213161
Gitweb:     http://git.kernel.org/tip/4451646b745acafc89a88a17f09c6d0be4213161
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:01 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 11:04:47 +0100

x86, irq: Replace printk(KERN_LVL) with pr_lvl() utilities

Replace printk(KENR_LVL) with pr_lvl() to keep checkpatch script silent.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1414397531-28254-11-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/vector.c | 69 +++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 641bbaa..c03d5ca 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -504,28 +504,27 @@ static void __init print_local_APIC(void *dummy)
 	unsigned int i, v, ver, maxlvt;
 	u64 icr;
 
-	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
-		smp_processor_id(), hard_smp_processor_id());
+	pr_debug("printing local APIC contents on CPU#%d/%d:\n",
+		 smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
+	pr_info("... APIC ID:      %08x (%01x)\n", v, read_apic_id());
 	v = apic_read(APIC_LVR);
-	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
+	pr_info("... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);
 	maxlvt = lapic_get_maxlvt();
 
 	v = apic_read(APIC_TASKPRI);
-	printk(KERN_DEBUG "... APIC TASKPRI: %08x (%02x)\n",
-	       v, v & APIC_TPRI_MASK);
+	pr_debug("... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
 
 	/* !82489DX */
 	if (APIC_INTEGRATED(ver)) {
 		if (!APIC_XAPIC(ver)) {
 			v = apic_read(APIC_ARBPRI);
-			printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
-			       v & APIC_ARBPRI_MASK);
+			pr_debug("... APIC ARBPRI: %08x (%02x)\n",
+				 v, v & APIC_ARBPRI_MASK);
 		}
 		v = apic_read(APIC_PROCPRI);
-		printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
+		pr_debug("... APIC PROCPRI: %08x\n", v);
 	}
 
 	/*
@@ -534,23 +533,23 @@ static void __init print_local_APIC(void *dummy)
 	 */
 	if (!APIC_INTEGRATED(ver) || maxlvt == 3) {
 		v = apic_read(APIC_RRR);
-		printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
+		pr_debug("... APIC RRR: %08x\n", v);
 	}
 
 	v = apic_read(APIC_LDR);
-	printk(KERN_DEBUG "... APIC LDR: %08x\n", v);
+	pr_debug("... APIC LDR: %08x\n", v);
 	if (!x2apic_enabled()) {
 		v = apic_read(APIC_DFR);
-		printk(KERN_DEBUG "... APIC DFR: %08x\n", v);
+		pr_debug("... APIC DFR: %08x\n", v);
 	}
 	v = apic_read(APIC_SPIV);
-	printk(KERN_DEBUG "... APIC SPIV: %08x\n", v);
+	pr_debug("... APIC SPIV: %08x\n", v);
 
-	printk(KERN_DEBUG "... APIC ISR field:\n");
+	pr_debug("... APIC ISR field:\n");
 	print_APIC_field(APIC_ISR);
-	printk(KERN_DEBUG "... APIC TMR field:\n");
+	pr_debug("... APIC TMR field:\n");
 	print_APIC_field(APIC_TMR);
-	printk(KERN_DEBUG "... APIC IRR field:\n");
+	pr_debug("... APIC IRR field:\n");
 	print_APIC_field(APIC_IRR);
 
 	/* !82489DX */
@@ -560,48 +559,48 @@ static void __init print_local_APIC(void *dummy)
 			apic_write(APIC_ESR, 0);
 
 		v = apic_read(APIC_ESR);
-		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
+		pr_debug("... APIC ESR: %08x\n", v);
 	}
 
 	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", (u32)icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (u32)(icr >> 32));
+	pr_debug("... APIC ICR: %08x\n", (u32)icr);
+	pr_debug("... APIC ICR2: %08x\n", (u32)(icr >> 32));
 
 	v = apic_read(APIC_LVTT);
-	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
+	pr_debug("... APIC LVTT: %08x\n", v);
 
 	if (maxlvt > 3) {
 		/* PC is LVT#4. */
 		v = apic_read(APIC_LVTPC);
-		printk(KERN_DEBUG "... APIC LVTPC: %08x\n", v);
+		pr_debug("... APIC LVTPC: %08x\n", v);
 	}
 	v = apic_read(APIC_LVT0);
-	printk(KERN_DEBUG "... APIC LVT0: %08x\n", v);
+	pr_debug("... APIC LVT0: %08x\n", v);
 	v = apic_read(APIC_LVT1);
-	printk(KERN_DEBUG "... APIC LVT1: %08x\n", v);
+	pr_debug("... APIC LVT1: %08x\n", v);
 
 	if (maxlvt > 2) {
 		/* ERR is LVT#3. */
 		v = apic_read(APIC_LVTERR);
-		printk(KERN_DEBUG "... APIC LVTERR: %08x\n", v);
+		pr_debug("... APIC LVTERR: %08x\n", v);
 	}
 
 	v = apic_read(APIC_TMICT);
-	printk(KERN_DEBUG "... APIC TMICT: %08x\n", v);
+	pr_debug("... APIC TMICT: %08x\n", v);
 	v = apic_read(APIC_TMCCT);
-	printk(KERN_DEBUG "... APIC TMCCT: %08x\n", v);
+	pr_debug("... APIC TMCCT: %08x\n", v);
 	v = apic_read(APIC_TDCR);
-	printk(KERN_DEBUG "... APIC TDCR: %08x\n", v);
+	pr_debug("... APIC TDCR: %08x\n", v);
 
 	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
 		v = apic_read(APIC_EFEAT);
 		maxlvt = (v >> 16) & 0xff;
-		printk(KERN_DEBUG "... APIC EFEAT: %08x\n", v);
+		pr_debug("... APIC EFEAT: %08x\n", v);
 		v = apic_read(APIC_ECTRL);
-		printk(KERN_DEBUG "... APIC ECTRL: %08x\n", v);
+		pr_debug("... APIC ECTRL: %08x\n", v);
 		for (i = 0; i < maxlvt; i++) {
 			v = apic_read(APIC_EILVTn(i));
-			printk(KERN_DEBUG "... APIC EILVT%d: %08x\n", i, v);
+			pr_debug("... APIC EILVT%d: %08x\n", i, v);
 		}
 	}
 	pr_cont("\n");
@@ -631,15 +630,15 @@ static void __init print_PIC(void)
 	if (!nr_legacy_irqs())
 		return;
 
-	printk(KERN_DEBUG "\nprinting PIC contents\n");
+	pr_debug("\nprinting PIC contents\n");
 
 	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
 	v = inb(0xa1) << 8 | inb(0x21);
-	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v);
+	pr_debug("... PIC  IMR: %04x\n", v);
 
 	v = inb(0xa0) << 8 | inb(0x20);
-	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v);
+	pr_debug("... PIC  IRR: %04x\n", v);
 
 	outb(0x0b, 0xa0);
 	outb(0x0b, 0x20);
@@ -649,10 +648,10 @@ static void __init print_PIC(void)
 
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
+	pr_debug("... PIC  ISR: %04x\n", v);
 
 	v = inb(0x4d1) << 8 | inb(0x4d0);
-	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
+	pr_debug("... PIC ELCR: %04x\n", v);
 }
 
 static int show_lapic __initdata = 1;
