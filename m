Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3LPUZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:25:52 -0500
Received: from 20.mo1.mail-out.ovh.net ([188.165.45.168]:49861 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752213Ab3LPUZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:25:50 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 03/10] ARM: at91: introduce OLD_IRQ_AT91 Kconfig option
Date: Mon, 16 Dec 2013 21:24:14 +0100
Message-Id: <1387225461-6201-4-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387225461-6201-1-git-send-email-b.brezillon@overkiz.com>
References: <1387225461-6201-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 7053481443320035429
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new Kconfig option OLD_IRQ_AT91 to prepare migration to the new
AIC driver.

Enable this option for all supported at91 SoCs (both dt and non-dt boards).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/Kconfig        |    7 +++++++
 arch/arm/mach-at91/Kconfig.non_dt |    7 +++++++
 arch/arm/mach-at91/Makefile       |    3 ++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index b4f7d6f..e1e6ff4 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -28,6 +28,10 @@ config OLD_CLK_AT91
 	bool
 	default AT91_PMC_UNIT && AT91_USE_OLD_CLK
 
+config OLD_IRQ_AT91
+	bool
+	default false
+
 config AT91_SAM9_ALT_RESET
 	bool
 	default !ARCH_AT91X40
@@ -190,6 +194,7 @@ config MACH_AT91RM9200_DT
 	bool "Atmel AT91RM9200 Evaluation Kits with device-tree support"
 	depends on SOC_AT91RM9200
 	select USE_OF
+	select OLD_IRQ_AT91
 	help
 	  Select this if you want to experiment device-tree with
 	  an Atmel RM9200 Evaluation Kit.
@@ -198,6 +203,7 @@ config MACH_AT91SAM9_DT
 	bool "Atmel AT91SAM Evaluation Kits with device-tree support"
 	depends on SOC_AT91SAM9
 	select USE_OF
+	select OLD_IRQ_AT91
 	help
 	  Select this if you want to experiment device-tree with
 	  an Atmel Evaluation Kit.
@@ -206,6 +212,7 @@ config MACH_SAMA5_DT
 	bool "Atmel SAMA5 Evaluation Kits with device-tree support"
 	depends on SOC_SAMA5
 	select USE_OF
+	select OLD_IRQ_AT91
 	select PHYLIB if NETDEVICES
 	help
 	  Select this if you want to experiment device-tree with
diff --git a/arch/arm/mach-at91/Kconfig.non_dt b/arch/arm/mach-at91/Kconfig.non_dt
index b736b57..87dc5e1 100644
--- a/arch/arm/mach-at91/Kconfig.non_dt
+++ b/arch/arm/mach-at91/Kconfig.non_dt
@@ -13,31 +13,37 @@ config ARCH_AT91RM9200
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
 
 config ARCH_AT91X40
 	bool "AT91x40"
@@ -45,6 +51,7 @@ config ARCH_AT91X40
 	select ARCH_USES_GETTIMEOFFSET
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
+	select OLD_IRQ_AT91
 
 endchoice
 
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 705b38a..960c9dd 100644
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
1.7.9.5

