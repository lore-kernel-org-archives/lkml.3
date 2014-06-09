Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaFIITF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:19:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:2900 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbaFIIS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:18:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352320043"
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
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch V4 11/42] x86, ioapic: kill unused global variable timer_through_8259
Date: Mon,  9 Jun 2014 16:19:40 +0800
Message-Id: <1402302011-23642-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    4 ----
 arch/x86/kernel/apic/io_apic.c |    3 ---
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 8dd1e13f2989..de3d8b04cf64 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -130,9 +130,6 @@ extern int noioapicquirk;
 /* -1 if "noapic" boot option passed */
 extern int noioapicreroute;
 
-/* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
-extern int timer_through_8259;
-
 /*
  * If we use the IO-APIC for IRQ routing, disable automatic
  * assignment of PCI IRQ's.
@@ -212,7 +209,6 @@ extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
-static const int timer_through_8259 = 0;
 static inline void ioapic_insert_resources(void) { }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d4aba16e6bbf..94a56c233e87 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2638,8 +2638,6 @@ static int __init disable_timer_pin_setup(char *arg)
 }
 early_param("disable_timer_pin_1", disable_timer_pin_setup);
 
-int timer_through_8259 __initdata;
-
 /*
  * This code may look a bit paranoid, but it's supposed to cooperate with
  * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
@@ -2744,7 +2742,6 @@ static inline void __init check_timer(void)
 		legacy_pic->unmask(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
-			timer_through_8259 = 1;
 			goto out;
 		}
 		/*
-- 
1.7.10.4

