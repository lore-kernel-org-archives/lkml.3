Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaIKI1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:27:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:40384 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbaIKIXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:23:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571629128"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Part1 v1 09/18] x86, irq: Replace printk(KERN_LVL) with pr_lvl() utilities
Date: Thu, 11 Sep 2014 16:24:56 +0800
Message-Id: <1410423905-26239-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace printk(KENR_LVL) with pr_lvl() to keep checkpatch script silent.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/vector.c |   69 ++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 248ad962c09a..f728cbfc29a9 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -506,27 +506,26 @@ static void __init print_local_APIC(void *dummy)
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
 
 	if (APIC_INTEGRATED(ver)) {                     /* !82489DX */
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
@@ -535,23 +534,23 @@ static void __init print_local_APIC(void *dummy)
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
 
 	if (APIC_INTEGRATED(ver)) {             /* !82489DX */
@@ -559,46 +558,46 @@ static void __init print_local_APIC(void *dummy)
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
 
 	if (maxlvt > 3) {                       /* PC is LVT#4. */
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
 
 	if (maxlvt > 2) {			/* ERR is LVT#3. */
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
@@ -628,15 +627,15 @@ static void __init print_PIC(void)
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
@@ -646,10 +645,10 @@ static void __init print_PIC(void)
 
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
+	pr_debug("... PIC  ISR: %04x\n", v);
 
 	v = inb(0x4d1) << 8 | inb(0x4d0);
-	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
+	pr_debug("... PIC ELCR: %04x\n", v);
 }
 
 static int show_lapic __initdata = 1;
-- 
1.7.10.4

