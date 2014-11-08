Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaKHSLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:11:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:56543 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaKHSLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:11:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533206"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part3 v3 03/38] x86, irq: Kill unused pre_init_apic_IRQ0()
Date: Sun,  9 Nov 2014 02:13:03 +0800
Message-Id: <1415470418-10874-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there's no user of pre_init_apic_IRQ0(), so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    1 -
 arch/x86/kernel/apic/io_apic.c |   17 -----------------
 2 files changed, 18 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index bf006cce9418..3207143f0a44 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -204,7 +204,6 @@ extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
 extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
-extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 51936be8ab13..919afe772347 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3088,20 +3088,3 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
 
 	return ret;
 }
-
-/* Enable IOAPIC early just for system timer */
-void __init pre_init_apic_IRQ0(void)
-{
-	struct io_apic_irq_attr attr = { 0, 0, 0, 0 };
-
-	printk(KERN_INFO "Early APIC setup for system timer0\n");
-#ifndef CONFIG_SMP
-	physid_set_mask_of_physid(boot_cpu_physical_apicid,
-					 &phys_cpu_present_map);
-#endif
-	setup_local_APIC();
-
-	io_apic_setup_irq_pin(0, 0, &attr);
-	irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
-				      "edge");
-}
-- 
1.7.10.4

