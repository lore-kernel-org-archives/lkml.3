Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaFIIR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:17:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:13868 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672AbaFIIRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:17:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352319495"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch V4 02/42] x86, mpparse: use pr_lvl() helper utilities to replace printk(KERN_LVL)
Date: Mon,  9 Jun 2014 16:19:31 +0800
Message-Id: <1402302011-23642-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_lvl() helper utilities to replace printk(KERN_LVL) for readability,
no function changes. Also use pr_cont() to avoid multiple newlines in
one printk().

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/mpparse.c |   95 +++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d2b56489d70f..b10e1132f316 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -67,7 +67,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 		boot_cpu_physical_apicid = m->apicid;
 	}
 
-	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);
+	pr_info("Processor #%d%s\n", m->apicid, bootup_cpu);
 	generic_processor_info(apicid, m->apicver);
 }
 
@@ -87,9 +87,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
 
 #if MAX_MP_BUSSES < 256
 	if (m->busid >= MAX_MP_BUSSES) {
-		printk(KERN_WARNING "MP table busid value (%d) for bustype %s "
-		       " is too large, max. supported is %d\n",
-		       m->busid, str, MAX_MP_BUSSES - 1);
+		pr_warn("MP table busid value (%d) for bustype %s is too large, max. supported is %d\n",
+			m->busid, str, MAX_MP_BUSSES - 1);
 		return;
 	}
 #endif
@@ -110,7 +109,7 @@ static void __init MP_bus_info(struct mpc_bus *m)
 		mp_bus_id_to_type[m->busid] = MP_BUS_EISA;
 #endif
 	} else
-		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
+		pr_warn("Unknown bustype %s - ignoring\n", str);
 }
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
@@ -121,8 +120,8 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 
 static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 {
-	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
-		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
+	apic_printk(APIC_VERBOSE,
+		"Int: type %d, pol %d, trig %d, bus %02x, IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		mp_irq->irqtype, mp_irq->irqflag & 3,
 		(mp_irq->irqflag >> 2) & 3, mp_irq->srcbus,
 		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
@@ -135,8 +134,8 @@ static inline void __init MP_ioapic_info(struct mpc_ioapic *m) {}
 
 static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 {
-	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
-		" IRQ %02x, APIC ID %x, APIC LINT %02x\n",
+	apic_printk(APIC_VERBOSE,
+		"Lint: type %d, pol %d, trig %d, bus %02x, IRQ %02x, APIC ID %x, APIC LINT %02x\n",
 		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbusid,
 		m->srcbusirq, m->destapic, m->destapiclint);
 }
@@ -148,34 +147,33 @@ static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 {
 
 	if (memcmp(mpc->signature, MPC_SIGNATURE, 4)) {
-		printk(KERN_ERR "MPTABLE: bad signature [%c%c%c%c]!\n",
+		pr_err("MPTABLE: bad signature [%c%c%c%c]!\n",
 		       mpc->signature[0], mpc->signature[1],
 		       mpc->signature[2], mpc->signature[3]);
 		return 0;
 	}
 	if (mpf_checksum((unsigned char *)mpc, mpc->length)) {
-		printk(KERN_ERR "MPTABLE: checksum error!\n");
+		pr_err("MPTABLE: checksum error!\n");
 		return 0;
 	}
 	if (mpc->spec != 0x01 && mpc->spec != 0x04) {
-		printk(KERN_ERR "MPTABLE: bad table version (%d)!!\n",
-		       mpc->spec);
+		pr_err("MPTABLE: bad table version (%d)!!\n", mpc->spec);
 		return 0;
 	}
 	if (!mpc->lapic) {
-		printk(KERN_ERR "MPTABLE: null local APIC address!\n");
+		pr_err("MPTABLE: null local APIC address!\n");
 		return 0;
 	}
 	memcpy(oem, mpc->oem, 8);
 	oem[8] = 0;
-	printk(KERN_INFO "MPTABLE: OEM ID: %s\n", oem);
+	pr_info("MPTABLE: OEM ID: %s\n", oem);
 
 	memcpy(str, mpc->productid, 12);
 	str[12] = 0;
 
-	printk(KERN_INFO "MPTABLE: Product ID: %s\n", str);
+	pr_info("MPTABLE: Product ID: %s\n", str);
 
-	printk(KERN_INFO "MPTABLE: APIC at: 0x%X\n", mpc->lapic);
+	pr_info("MPTABLE: APIC at: 0x%X\n", mpc->lapic);
 
 	return 1;
 }
@@ -188,8 +186,8 @@ static void skip_entry(unsigned char **ptr, int *count, int size)
 
 static void __init smp_dump_mptable(struct mpc_table *mpc, unsigned char *mpt)
 {
-	printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n"
-		"type %x\n", *mpt);
+	pr_err("Your mptable is wrong, contact your HW vendor!\n");
+	pr_cont("type %x\n", *mpt);
 	print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
 			1, mpc, mpc->length, 1);
 }
@@ -259,7 +257,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	}
 
 	if (!num_processors)
-		printk(KERN_ERR "MPTABLE: no processors registered!\n");
+		pr_err("MPTABLE: no processors registered!\n");
 	return num_processors;
 }
 
@@ -295,16 +293,13 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 	 *  If it does, we assume it's valid.
 	 */
 	if (mpc_default_type == 5) {
-		printk(KERN_INFO "ISA/PCI bus type with no IRQ information... "
-		       "falling back to ELCR\n");
+		pr_info("ISA/PCI bus type with no IRQ information... falling back to ELCR\n");
 
 		if (ELCR_trigger(0) || ELCR_trigger(1) || ELCR_trigger(2) ||
 		    ELCR_trigger(13))
-			printk(KERN_ERR "ELCR contains invalid data... "
-			       "not using ELCR\n");
+			pr_err("ELCR contains invalid data... not using ELCR\n");
 		else {
-			printk(KERN_INFO
-			       "Using ELCR to identify PCI interrupts\n");
+			pr_info("Using ELCR to identify PCI interrupts\n");
 			ELCR_fallback = 1;
 		}
 	}
@@ -353,7 +348,7 @@ static void __init construct_ioapic_table(int mpc_default_type)
 	bus.busid = 0;
 	switch (mpc_default_type) {
 	default:
-		printk(KERN_ERR "???\nUnknown standard configuration %d\n",
+		pr_err("???\nUnknown standard configuration %d\n",
 		       mpc_default_type);
 		/* fall through */
 	case 1:
@@ -462,8 +457,8 @@ static int __init check_physptr(struct mpf_intel *mpf, unsigned int early)
 #ifdef CONFIG_X86_LOCAL_APIC
 		smp_found_config = 0;
 #endif
-		printk(KERN_ERR "BIOS bug, MP table errors detected!...\n"
-			"... disabling SMP support. (tell your hw vendor)\n");
+		pr_err("BIOS bug, MP table errors detected!...\n");
+		pr_cont("... disabling SMP support. (tell your hw vendor)\n");
 		early_iounmap(mpc, size);
 		return -1;
 	}
@@ -481,8 +476,7 @@ static int __init check_physptr(struct mpf_intel *mpf, unsigned int early)
 	if (!mp_irq_entries) {
 		struct mpc_bus bus;
 
-		printk(KERN_ERR "BIOS bug, no explicit IRQ entries, "
-		       "using default mptable. (tell your hw vendor)\n");
+		pr_err("BIOS bug, no explicit IRQ entries, using default mptable. (tell your hw vendor)\n");
 
 		bus.type = MP_BUS;
 		bus.busid = 0;
@@ -516,14 +510,14 @@ void __init default_get_smp_config(unsigned int early)
 	if (acpi_lapic && acpi_ioapic)
 		return;
 
-	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
-	       mpf->specification);
+	pr_info("Intel MultiProcessor Specification v1.%d\n",
+		mpf->specification);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
 	if (mpf->feature2 & (1 << 7)) {
-		printk(KERN_INFO "    IMCR and PIC compatibility mode.\n");
+		pr_info("    IMCR and PIC compatibility mode.\n");
 		pic_mode = 1;
 	} else {
-		printk(KERN_INFO "    Virtual Wire compatibility mode.\n");
+		pr_info("    Virtual Wire compatibility mode.\n");
 		pic_mode = 0;
 	}
 #endif
@@ -539,8 +533,7 @@ void __init default_get_smp_config(unsigned int early)
 			return;
 		}
 
-		printk(KERN_INFO "Default MP configuration #%d\n",
-		       mpf->feature1);
+		pr_info("Default MP configuration #%d\n", mpf->feature1);
 		construct_default_ISA_mptable(mpf->feature1);
 
 	} else if (mpf->physptr) {
@@ -550,7 +543,7 @@ void __init default_get_smp_config(unsigned int early)
 		BUG();
 
 	if (!early)
-		printk(KERN_INFO "Processors: %d\n", num_processors);
+		pr_info("Processors: %d\n", num_processors);
 	/*
 	 * Only use the first configuration found.
 	 */
@@ -583,10 +576,10 @@ static int __init smp_scan_config(unsigned long base, unsigned long length)
 #endif
 			mpf_found = mpf;
 
-			printk(KERN_INFO "found SMP MP-table at [mem %#010llx-%#010llx] mapped at [%p]\n",
-			       (unsigned long long) virt_to_phys(mpf),
-			       (unsigned long long) virt_to_phys(mpf) +
-			       sizeof(*mpf) - 1, mpf);
+			pr_info("found SMP MP-table at [mem %#010llx-%#010llx] mapped at [%p]\n",
+				(unsigned long long) virt_to_phys(mpf),
+				(unsigned long long) virt_to_phys(mpf) +
+				sizeof(*mpf) - 1, mpf);
 
 			mem = virt_to_phys(mpf);
 			memblock_reserve(mem, sizeof(*mpf));
@@ -735,7 +728,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 	int nr_m_spare = 0;
 	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
-	printk(KERN_INFO "mpc_length %x\n", mpc->length);
+	pr_info("mpc_length %x\n", mpc->length);
 	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
@@ -862,13 +855,13 @@ static int __init update_mp_table(void)
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
-	printk(KERN_INFO "mpf: %llx\n", (u64)virt_to_phys(mpf));
-	printk(KERN_INFO "physptr: %x\n", mpf->physptr);
+	pr_info("mpf: %llx\n", (u64)virt_to_phys(mpf));
+	pr_info("physptr: %x\n", mpf->physptr);
 
 	if (mpc_new_phys && mpc->length > mpc_new_length) {
 		mpc_new_phys = 0;
-		printk(KERN_INFO "mpc_new_length is %ld, please use alloc_mptable=8k\n",
-			 mpc_new_length);
+		pr_info("mpc_new_length is %ld, please use alloc_mptable=8k\n",
+			mpc_new_length);
 	}
 
 	if (!mpc_new_phys) {
@@ -879,10 +872,10 @@ static int __init update_mp_table(void)
 		mpc->checksum = 0xff;
 		new = mpf_checksum((unsigned char *)mpc, mpc->length);
 		if (old == new) {
-			printk(KERN_INFO "mpc is readonly, please try alloc_mptable instead\n");
+			pr_info("mpc is readonly, please try alloc_mptable instead\n");
 			return 0;
 		}
-		printk(KERN_INFO "use in-position replacing\n");
+		pr_info("use in-position replacing\n");
 	} else {
 		mpf->physptr = mpc_new_phys;
 		mpc_new = phys_to_virt(mpc_new_phys);
@@ -892,7 +885,7 @@ static int __init update_mp_table(void)
 		if (mpc_new_phys - mpf->physptr) {
 			struct mpf_intel *mpf_new;
 			/* steal 16 bytes from [0, 1k) */
-			printk(KERN_INFO "mpf new: %x\n", 0x400 - 16);
+			pr_info("mpf new: %x\n", 0x400 - 16);
 			mpf_new = phys_to_virt(0x400 - 16);
 			memcpy(mpf_new, mpf, 16);
 			mpf = mpf_new;
@@ -900,7 +893,7 @@ static int __init update_mp_table(void)
 		}
 		mpf->checksum = 0;
 		mpf->checksum -= mpf_checksum((unsigned char *)mpf, 16);
-		printk(KERN_INFO "physptr new: %x\n", mpf->physptr);
+		pr_info("physptr new: %x\n", mpf->physptr);
 	}
 
 	/*
-- 
1.7.10.4

