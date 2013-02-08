Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947022Ab3BHTfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:35:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26388 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760466Ab3BHT3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:29:38 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 01/26] x86, irq: Change irq_remap_modify_chip_defaults to static
Date: Fri,  8 Feb 2013 11:27:58 -0800
Message-Id: <1360351703-20571-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
 arch/x86/include/asm/irq_remapping.h |    6 ------
 drivers/iommu/irq_remapping.c        |    2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 95fd352..06279a6 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -48,8 +48,6 @@ extern bool setup_remapped_irq(int irq,
 			       struct irq_cfg *cfg,
 			       struct irq_chip *chip);
 
-void irq_remap_modify_chip_defaults(struct irq_chip *chip);
-
 #else  /* CONFIG_IRQ_REMAP */
 
 static inline void setup_irq_remapping_ops(void) { }
@@ -82,10 +80,6 @@ static inline void panic_if_irq_remap(const char *msg)
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
index d56f8c1..01ed477 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -368,7 +368,7 @@ static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
 	seq_printf(p, " IR-%s", data->chip->name);
 }
 
-void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 {
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
-- 
1.7.10.4

