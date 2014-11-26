Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaKZXTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:19:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaKZXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:19:13 -0500
Date: Wed, 26 Nov 2014 15:13:23 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-afc1bcbe31c10f5ae16df532398f1bb164448558@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, joro@8bytes.org,
        bhelgaas@google.com, rjw@rjwysocki.net, bp@alien8.de,
        andriy.shevchenko@linux.intel.com, rdunlap@infradead.org,
        hpa@zytor.com, yinghai@kernel.org, grant.likely@linaro.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, tony.luck@intel.com,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org,
        jiang.liu@linux.intel.com
Reply-To: tony.luck@intel.com, tglx@linutronix.de, konrad.wilk@oracle.com,
        grant.likely@linaro.org, jiang.liu@linux.intel.com,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        bhelgaas@google.com, joro@8bytes.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, hpa@zytor.com,
        rdunlap@infradead.org, andriy.shevchenko@linux.intel.com, bp@alien8.de,
        rjw@rjwysocki.net
In-Reply-To: <1416901802-24211-4-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-4-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Kill unused pre_init_apic_IRQ0()
Git-Commit-ID: afc1bcbe31c10f5ae16df532398f1bb164448558
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

Commit-ID:  afc1bcbe31c10f5ae16df532398f1bb164448558
Gitweb:     http://git.kernel.org/tip/afc1bcbe31c10f5ae16df532398f1bb164448558
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:27 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:46 +0100

x86, irq: Kill unused pre_init_apic_IRQ0()

Now there's no user of pre_init_apic_IRQ0(), so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-4-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |  1 -
 arch/x86/kernel/apic/io_apic.c | 17 -----------------
 2 files changed, 18 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index bf006cc..3207143 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -204,7 +204,6 @@ extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
 extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
-extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 51936be..919afe7 100644
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
