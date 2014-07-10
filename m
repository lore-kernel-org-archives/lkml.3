Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaGJRPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:15:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57593 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbaGJROf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:14:35 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 4/7] ARM: at91: introduce OLD_IRQ_AT91 Kconfig option
Date: Thu, 10 Jul 2014 19:14:19 +0200
Message-Id: <1405012462-766-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the OLD_IRQ_AT91 Kconfig option to prepare migration to the
new AIC driver.

Select this option for all at91 SoCs and all available boards so that we
can later move DT enabled boards to the new irq driver and keep the old
implementation when legacy boards are selected.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig        | 17 +++++++++--------
 arch/arm/mach-at91/Kconfig.non_dt |  6 ++++++
 arch/arm/mach-at91/Makefile       |  3 ++-
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 45b55e0..8e5ea10 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -28,6 +28,11 @@ config OLD_CLK_AT91
 	bool
 	default AT91_PMC_UNIT && AT91_USE_OLD_CLK
 
+config OLD_IRQ_AT91
+	bool
+	select MULTI_IRQ_HANDLER
+	select SPARSE_IRQ
+
 config AT91_SAM9_ALT_RESET
 	bool
 	default !ARCH_AT91X40
@@ -47,16 +52,12 @@ config SOC_AT91SAM9
 	select AT91_SAM9_TIME
 	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
-	select MULTI_IRQ_HANDLER
-	select SPARSE_IRQ
 
 config SOC_SAMA5
 	bool
 	select AT91_SAM9_TIME
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
-	select MULTI_IRQ_HANDLER
-	select SPARSE_IRQ
 	select USE_OF
 
 menu "Atmel AT91 System-on-Chip"
@@ -70,8 +71,7 @@ config ARCH_AT91X40
 	depends on !MMU
 	select CPU_ARM7TDMI
 	select ARCH_USES_GETTIMEOFFSET
-	select MULTI_IRQ_HANDLER
-	select SPARSE_IRQ
+	select OLD_IRQ_AT91
 
 	help
 	  Select this if you are using one of Atmel's AT91X40 SoC.
@@ -111,8 +111,6 @@ config SOC_AT91RM9200
 	select CPU_ARM920T
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_DBGU0
-	select MULTI_IRQ_HANDLER
-	select SPARSE_IRQ
 	select AT91_USE_OLD_CLK
 	select HAVE_AT91_USB_CLK
 
@@ -199,6 +197,7 @@ comment "Generic Board Type"
 config MACH_AT91RM9200_DT
 	bool "Atmel AT91RM9200 Evaluation Kits with device-tree support"
 	depends on SOC_AT91RM9200
+	select OLD_IRQ_AT91
 	select USE_OF
 	help
 	  Select this if you want to experiment device-tree with
@@ -207,6 +206,7 @@ config MACH_AT91RM9200_DT
 config MACH_AT91SAM9_DT
 	bool "Atmel AT91SAM Evaluation Kits with device-tree support"
 	depends on SOC_AT91SAM9
+	select OLD_IRQ_AT91
 	select USE_OF
 	help
 	  Select this if you want to experiment device-tree with
@@ -215,6 +215,7 @@ config MACH_AT91SAM9_DT
 config MACH_SAMA5_DT
 	bool "Atmel SAMA5 Evaluation Kits with device-tree support"
 	depends on SOC_SAMA5
+	select OLD_IRQ_AT91
 	select USE_OF
 	select PHYLIB if NETDEVICES
 	help
diff --git a/arch/arm/mach-at91/Kconfig.non_dt b/arch/arm/mach-at91/Kconfig.non_dt
index 44ace32..b774c3d 100644
--- a/arch/arm/mach-at91/Kconfig.non_dt
+++ b/arch/arm/mach-at91/Kconfig.non_dt
@@ -14,31 +14,37 @@ config ARCH_AT91RM9200
 	bool "AT91RM9200"
 	select SOC_AT91RM9200
 	select AT91_USE_OLD_CLK
+	select OLD_IRQ_AT91
 
 config ARCH_AT91SAM9260
 	bool "AT91SAM9260 or AT91SAM9XE or AT91SAM9G20"
 	select SOC_AT91SAM9260
 	select AT91_USE_OLD_CLK
+	select OLD_IRQ_AT91
 
 config ARCH_AT91SAM9261
 	bool "AT91SAM9261 or AT91SAM9G10"
 	select SOC_AT91SAM9261
 	select AT91_USE_OLD_CLK
+	select OLD_IRQ_AT91
 
 config ARCH_AT91SAM9263
 	bool "AT91SAM9263"
 	select SOC_AT91SAM9263
 	select AT91_USE_OLD_CLK
+	select OLD_IRQ_AT91
 
 config ARCH_AT91SAM9RL
 	bool "AT91SAM9RL"
 	select SOC_AT91SAM9RL
 	select AT91_USE_OLD_CLK
+	select OLD_IRQ_AT91
 
 config ARCH_AT91SAM9G45
 	bool "AT91SAM9G45"
 	select SOC_AT91SAM9G45
 	select AT91_USE_OLD_CLK
+	select OLD_IRQ_AT91
 
 endchoice
 
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 78e9cec..d972fd6 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -2,11 +2,12 @@
 # Makefile for the linux kernel.
 #
 
-obj-y		:= irq.o gpio.o setup.o sysirq_mask.o
+obj-y		:= gpio.o setup.o sysirq_mask.o
 obj-m		:=
 obj-n		:=
 obj-		:=
 
+obj-$(CONFIG_OLD_IRQ_AT91)	+= irq.o
 obj-$(CONFIG_OLD_CLK_AT91)	+= clock.o
 obj-$(CONFIG_AT91_SAM9_ALT_RESET) += at91sam9_alt_reset.o
 obj-$(CONFIG_AT91_SAM9G45_RESET) += at91sam9g45_reset.o
-- 
1.8.3.2

