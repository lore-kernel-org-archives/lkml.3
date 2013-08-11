Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3HKCzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:55:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34748 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3HKCss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:48:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v4 04/28] x86, irq: Change irq_remap_modify_chip_defaults() to static
Date: Sat, 10 Aug 2013 19:47:50 -0700
Message-Id: <1376189294-32022-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change irq_remap_modify_chip_defaults() to static, as we have no
outside user.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/irq_remapping.h | 6 ------
 drivers/iommu/irq_remapping.c        | 2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index d806b22..606f42e 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -56,8 +56,6 @@ extern bool setup_remapped_irq(int irq,
 			       struct irq_cfg *cfg,
 			       struct irq_chip *chip);
 
-void irq_remap_modify_chip_defaults(struct irq_chip *chip);
-
 #else  /* CONFIG_IRQ_REMAP */
 
 static inline void setup_irq_remapping_ops(void) { }
@@ -91,10 +89,6 @@ static inline void panic_if_irq_remap(const char *msg)
 {
 }
 
-static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
-{
-}
-
 static inline bool setup_remapped_irq(int irq,
 				      struct irq_cfg *cfg,
 				      struct irq_chip *chip)
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 39f81ae..85ae2cf 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -375,7 +375,7 @@ static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
 	seq_printf(p, " IR-%s", data->chip->name);
 }
 
-void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 {
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
-- 
1.8.1.4

