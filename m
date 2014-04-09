Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbaDIOeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:34:09 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:38239 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761AbaDIOeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:34:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Christopher Covington <cov@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2] ARM: msm: Make MSM_HAS_DEBUG_UART_HS option visible to multiplatform targets
Date: Wed,  9 Apr 2014 17:26:25 +0300
Message-Id: <1397053585-26201-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <53455268.4030003@codeaurora.org>
References: <53455268.4030003@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

High Speed UART is available also in new multiplatform QCOM targets.

This fixes:

scripts/kconfig/conf --silentoldconfig Kconfig
warning: (DEBUG_MSM8660_UART && DEBUG_MSM8960_UART && DEBUG_MSM8974_UART) selects MSM_HAS_DEBUG_UART_HS which has unmet direct dependencies (ARCH_MSM)
warning: (DEBUG_MSM8660_UART && DEBUG_MSM8960_UART && DEBUG_MSM8974_UART) selects MSM_HAS_DEBUG_UART_HS which has unmet direct dependencies (ARCH_MSM)

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 arch/arm/Kconfig.debug       | 3 ---
 arch/arm/include/debug/msm.S | 7 +++++--
 arch/arm/mach-msm/Kconfig    | 3 ---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 4a2fc0bf..320a335 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -376,7 +376,6 @@ choice
 	config DEBUG_MSM8660_UART
 		bool "Kernel low-level debugging messages via MSM 8660 UART"
 		depends on ARCH_MSM8X60
-		select MSM_HAS_DEBUG_UART_HS
 		select DEBUG_MSM_UART
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -385,7 +384,6 @@ choice
 	config DEBUG_MSM8960_UART
 		bool "Kernel low-level debugging messages via MSM 8960 UART"
 		depends on ARCH_MSM8960
-		select MSM_HAS_DEBUG_UART_HS
 		select DEBUG_MSM_UART
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -394,7 +392,6 @@ choice
 	config DEBUG_MSM8974_UART
 		bool "Kernel low-level debugging messages via MSM 8974 UART"
 		depends on ARCH_MSM8974
-		select MSM_HAS_DEBUG_UART_HS
 		select DEBUG_MSM_UART
 		help
 		  Say Y here if you want the debug print routines to direct
diff --git a/arch/arm/include/debug/msm.S b/arch/arm/include/debug/msm.S
index 9d653d4..0ba84e6 100644
--- a/arch/arm/include/debug/msm.S
+++ b/arch/arm/include/debug/msm.S
@@ -39,16 +39,19 @@
 #ifdef CONFIG_DEBUG_MSM8660_UART
 #define MSM_DEBUG_UART_BASE	0xF0040000
 #define MSM_DEBUG_UART_PHYS	0x19C40000
+#define MSM_HAS_DEBUG_UART_HS
 #endif

 #ifdef CONFIG_DEBUG_MSM8960_UART
 #define MSM_DEBUG_UART_BASE	0xF0040000
 #define MSM_DEBUG_UART_PHYS	0x16440000
+#define MSM_HAS_DEBUG_UART_HS
 #endif

 #ifdef CONFIG_DEBUG_MSM8974_UART
 #define MSM_DEBUG_UART_BASE	0xFA71E000
 #define MSM_DEBUG_UART_PHYS	0xF991E000
+#define MSM_HAS_DEBUG_UART_HS
 #endif

 	.macro	addruart, rp, rv, tmp
@@ -59,7 +62,7 @@
 	.endm

 	.macro	senduart, rd, rx
-#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
+#ifdef MSM_HAS_DEBUG_UART_HS
 	@ Write the 1 character to UARTDM_TF
 	str	\rd, [\rx, #0x70]
 #else
@@ -68,7 +71,7 @@
 	.endm

 	.macro	waituart, rd, rx
-#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
+#ifdef MSM_HAS_DEBUG_UART_HS
 	@ check for TX_EMT in UARTDM_SR
 	ldr	\rd, [\rx, #0x08]
 	tst	\rd, #0x08
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index a7f959e..9b26976 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -42,9 +42,6 @@ config ARCH_QSD8X50

 endchoice

-config MSM_HAS_DEBUG_UART_HS
-	bool
-
 config MSM_SOC_REV_A
 	bool

--
1.8.3.2

