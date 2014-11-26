Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaKZXUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:20:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaKZXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:20:53 -0500
Date: Wed, 26 Nov 2014 15:19:54 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-80c34e37c15ab8f98c6b20900d74e04bf99fee99@git.kernel.org>
Cc: bhelgaas@google.com, tony.luck@intel.com, jiang.liu@linux.intel.com,
        rjw@rjwysocki.net, mingo@kernel.org, grant.likely@linaro.org,
        jroedel@suse.de, joro@8bytes.org, benh@kernel.crashing.org,
        hpa@zytor.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        yinghai@kernel.org, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, konrad.wilk@oracle.com
Reply-To: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        gregkh@linuxfoundation.org, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, bp@alien8.de, rdunlap@infradead.org,
        jroedel@suse.de, joro@8bytes.org, mingo@kernel.org, rjw@rjwysocki.net,
        grant.likely@linaro.org, tony.luck@intel.com,
        jiang.liu@linux.intel.com, bhelgaas@google.com,
        benh@kernel.crashing.org
In-Reply-To: <1416901802-24211-29-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-29-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Clean up io_apic.h
Git-Commit-ID: 80c34e37c15ab8f98c6b20900d74e04bf99fee99
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

Commit-ID:  80c34e37c15ab8f98c6b20900d74e04bf99fee99
Gitweb:     http://git.kernel.org/tip/80c34e37c15ab8f98c6b20900d74e04bf99fee99
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:52 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:49 +0100

x86, irq: Clean up io_apic.h

Clean up io_apic.h by:
1) moving definition of struct mp_ioapic_gsi into io_apic.c
2) changing mp_pin_to_gsi() and mp_ioapic_gsi_routing() as static
3) killing unused MP_MAX_IOAPIC_PIN
4) killing useless forward declaration
5) killing useless comments

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
Link: http://lkml.kernel.org/r/1416901802-24211-29-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h | 14 ++------------
 arch/x86/kernel/apic/io_apic.c | 23 ++++++++---------------
 2 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 21578af..b569ae0 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -113,9 +113,6 @@ extern int nr_ioapics;
 
 extern int mpc_ioapic_id(int ioapic);
 extern unsigned int mpc_ioapic_addr(int ioapic);
-extern struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic);
-
-#define MP_MAX_IOAPIC_PIN 127
 
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;
@@ -135,6 +132,8 @@ extern int noioapicquirk;
 /* -1 if "noapic" boot option passed */
 extern int noioapicreroute;
 
+extern u32 gsi_top;
+
 extern unsigned long io_apic_irqs;
 
 #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1 << (x)) & io_apic_irqs))
@@ -146,7 +145,6 @@ extern unsigned long io_apic_irqs;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-struct irq_cfg;
 extern void ioapic_insert_resources(void);
 extern int arch_early_ioapic_init(void);
 
@@ -174,15 +172,8 @@ struct ioapic_domain_cfg {
 	struct device_node		*dev;
 };
 
-struct mp_ioapic_gsi{
-	u32 gsi_base;
-	u32 gsi_end;
-};
-extern u32 gsi_top;
-
 extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
-extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
 			     struct irq_alloc_info *info);
 extern void mp_unmap_irq(int irq);
@@ -231,7 +222,6 @@ static inline int arch_early_ioapic_init(void) { return 0; }
 static inline void print_IO_APICs(void) {}
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
-static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
 				    struct irq_alloc_info *info)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7a3679e..a915ee0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -63,7 +63,6 @@
 #define	for_each_ioapic_pin(idx, pin)	\
 	for_each_ioapic((idx))		\
 		for_each_pin((idx), (pin))
-
 #define for_each_irq_pin(entry, head) \
 	list_for_each_entry(entry, &head, list)
 
@@ -94,6 +93,11 @@ struct mp_chip_data {
 	bool isa_irq;
 };
 
+struct mp_ioapic_gsi {
+	u32 gsi_base;
+	u32 gsi_end;
+};
+
 static struct ioapic {
 	/*
 	 * # of IRQ routing registers
@@ -124,7 +128,7 @@ unsigned int mpc_ioapic_addr(int ioapic_idx)
 	return ioapics[ioapic_idx].mp_config.apicaddr;
 }
 
-struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
+static inline struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
 {
 	return &ioapics[ioapic_idx].gsi_config;
 }
@@ -136,7 +140,7 @@ static inline int mp_ioapic_pin_count(int ioapic)
 	return gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
 }
 
-u32 mp_pin_to_gsi(int ioapic, int pin)
+static inline u32 mp_pin_to_gsi(int ioapic, int pin)
 {
 	return mp_ioapic_gsi_routing(ioapic)->gsi_base + pin;
 }
@@ -1146,8 +1150,7 @@ static int pin_2_irq(int idx, int ioapic, int pin, unsigned int flags)
 	return  mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags, NULL);
 }
 
-int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
-		      struct irq_alloc_info *info)
+int mp_map_gsi_to_irq(u32 gsi, unsigned int flags, struct irq_alloc_info *info)
 {
 	int ioapic, pin, idx;
 
@@ -1709,7 +1712,6 @@ static int __init timer_irq_works(void)
  * This is not complete - we should be able to fake
  * an edge even if it isn't on the 8259A...
  */
-
 static unsigned int startup_ioapic_irq(struct irq_data *data)
 {
 	int was_pending = 0, irq = data->irq;
@@ -1727,15 +1729,6 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 	return was_pending;
 }
 
-/*
- * Level and edge triggered IO-APIC interrupts need different handling,
- * so we use two separate IRQ descriptors. Edge triggered IRQs can be
- * handled with the level-triggered descriptor, but that one has slightly
- * more overhead. Level-triggered interrupts cannot be handled with the
- * edge-triggered handler, without risking IRQ storms and other ugly
- * races.
- */
-
 static void __target_IO_APIC_irq(unsigned int irq, struct irq_cfg *cfg,
 				 struct mp_chip_data *data)
 {
