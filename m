Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaKZXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:16:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaKZXQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:16:23 -0500
Date: Wed, 26 Nov 2014 15:15:32 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-cc133128b0ed028b580a5e44ae6f414ede18f762@git.kernel.org>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, jroedel@suse.de, joro@8bytes.org,
        rdunlap@infradead.org, tglx@linutronix.de, bhelgaas@google.com,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org, mingo@kernel.org,
        rjw@rjwysocki.net, tony.luck@intel.com, hpa@zytor.com,
        grant.likely@linaro.org, konrad.wilk@oracle.com, bp@alien8.de
Reply-To: bhelgaas@google.com, gregkh@linuxfoundation.org,
        benh@kernel.crashing.org, mingo@kernel.org, rdunlap@infradead.org,
        tglx@linutronix.de, konrad.wilk@oracle.com, bp@alien8.de,
        rjw@rjwysocki.net, grant.likely@linaro.org, tony.luck@intel.com,
        hpa@zytor.com, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        jroedel@suse.de, joro@8bytes.org, jiang.liu@linux.intel.com
In-Reply-To: <1416901802-24211-12-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-12-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Kill unused struct mp_pin_info
Git-Commit-ID: cc133128b0ed028b580a5e44ae6f414ede18f762
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

Commit-ID:  cc133128b0ed028b580a5e44ae6f414ede18f762
Gitweb:     http://git.kernel.org/tip/cc133128b0ed028b580a5e44ae6f414ede18f762
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:47 +0100

x86, irq: Kill unused struct mp_pin_info

Now nobody makes use of struct mp_pin_info, so kill it.

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
Link: http://lkml.kernel.org/r/1416901802-24211-12-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/apic/io_apic.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 993a030..551108e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -88,13 +88,6 @@ struct mp_chip_data {
 	bool isa_irq;
 };
 
-struct mp_pin_info {
-	int trigger;
-	int polarity;
-	int set;
-	u32 count;
-};
-
 static struct ioapic {
 	/*
 	 * # of IRQ routing registers
@@ -110,7 +103,6 @@ static struct ioapic {
 	struct mp_ioapic_gsi  gsi_config;
 	struct ioapic_domain_cfg irqdomain_cfg;
 	struct irq_domain *irqdomain;
-	struct mp_pin_info *pin_info;
 	struct resource *iomem_res;
 } ioapics[MAX_IO_APICS];
 
@@ -156,11 +148,6 @@ static inline int mp_init_irq_at_boot(int ioapic, int irq)
 	return ioapic == 0 || (irq >= 0 && irq < nr_legacy_irqs());
 }
 
-static inline struct mp_pin_info *mp_pin_info(int ioapic_idx, int pin)
-{
-	return ioapics[ioapic_idx].pin_info + pin;
-}
-
 static inline struct irq_domain *mp_ioapic_irqdomain(int ioapic)
 {
 	return ioapics[ioapic].irqdomain;
@@ -2422,7 +2409,6 @@ out:
 
 static int mp_irqdomain_create(int ioapic)
 {
-	size_t size;
 	struct irq_alloc_info info;
 	struct irq_domain *parent;
 	int hwirqs = mp_ioapic_pin_count(ioapic);
@@ -2430,11 +2416,6 @@ static int mp_irqdomain_create(int ioapic)
 	struct ioapic_domain_cfg *cfg = &ip->irqdomain_cfg;
 	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
 
-	size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(ioapic);
-	ip->pin_info = kzalloc(size, GFP_KERNEL);
-	if (!ip->pin_info)
-		return -ENOMEM;
-
 	if (cfg->type == IOAPIC_DOMAIN_INVALID)
 		return 0;
 
@@ -2447,13 +2428,10 @@ static int mp_irqdomain_create(int ioapic)
 
 	ip->irqdomain = irq_domain_add_linear(cfg->dev, hwirqs, cfg->ops,
 					      (void *)(long)ioapic);
-	if (ip->irqdomain) {
-		ip->irqdomain->parent = parent;
-	} else {
-		kfree(ip->pin_info);
-		ip->pin_info = NULL;
+	if (!ip->irqdomain)
 		return -ENOMEM;
-	}
+
+	ip->irqdomain->parent = parent;
 
 	if (cfg->type == IOAPIC_DOMAIN_LEGACY ||
 	    cfg->type == IOAPIC_DOMAIN_STRICT)
@@ -2469,8 +2447,6 @@ static void ioapic_destroy_irqdomain(int idx)
 		irq_domain_remove(ioapics[idx].irqdomain);
 		ioapics[idx].irqdomain = NULL;
 	}
-	kfree(ioapics[idx].pin_info);
-	ioapics[idx].pin_info = NULL;
 }
 
 void __init setup_IO_APIC(void)
