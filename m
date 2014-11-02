Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaKBBFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 21:05:14 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51122 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaKBBFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 21:05:06 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org
Cc: linux-sh@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V3 12/14] irqchip: bcm7120-l2: Decouple driver from brcmstb-l2
Date: Sat,  1 Nov 2014 18:03:59 -0700
Message-Id: <1414890241-9938-13-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
References: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chips, such as BCM6328, only require bcm7120-l2.  Some BCM7xxx STB
configurations only require brcmstb-l2.  Treat them as two separate
entities, and update the mach-bcm dependencies to reflect the change.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/mach-bcm/Kconfig        | 1 +
 drivers/irqchip/Kconfig          | 5 +++++
 drivers/irqchip/Makefile         | 4 ++--
 drivers/irqchip/irq-bcm7120-l2.c | 2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 2abad74..bf47eb0 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -125,6 +125,7 @@ config ARCH_BRCMSTB
 	select HAVE_ARM_ARCH_TIMER
 	select BRCMSTB_GISB_ARB
 	select BRCMSTB_L2_IRQ
+	select BCM7120_L2_IRQ
 	help
 	  Say Y if you intend to run the kernel on a Broadcom ARM-based STB
 	  chipset.
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 09c79d1..afdc1f3 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -48,6 +48,11 @@ config ATMEL_AIC5_IRQ
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
 
+config BCM7120_L2_IRQ
+	bool
+	select GENERIC_IRQ_CHIP
+	select IRQ_DOMAIN
+
 config BRCMSTB_L2_IRQ
 	bool
 	select GENERIC_IRQ_CHIP
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 173bb5f..f0909d0 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -35,6 +35,6 @@ obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
 obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
 obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
 obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
-obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o \
-					   irq-bcm7120-l2.o
+obj-$(CONFIG_BCM7120_L2_IRQ)		+= irq-bcm7120-l2.o
+obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
 obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index ef4d32c..e53a3a6 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -247,5 +247,5 @@ out_unmap:
 	kfree(data);
 	return ret;
 }
-IRQCHIP_DECLARE(brcmstb_l2_intc, "brcm,bcm7120-l2-intc",
+IRQCHIP_DECLARE(bcm7120_l2_intc, "brcm,bcm7120-l2-intc",
 		bcm7120_l2_intc_of_init);
-- 
2.1.1

