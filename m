Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaLVQ62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:58:28 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45940 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaLVQ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:58:25 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Greg Ungerer <gerg@uclinux.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [PATCH 3.19-rc1 v14 4/8] arm: ks8695: Migrate debug_ll macros to shared directory
Date: Mon, 22 Dec 2014 16:57:21 +0000
Message-Id: <1419267445-8330-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419267445-8330-1-git-send-email-daniel.thompson@linaro.org>
References: <1419267445-8330-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the migration a couple of uart definitions have been copied
from of the platform specific header files.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
---
 arch/arm/Kconfig.debug                                         |  8 ++++++++
 .../include/mach/debug-macro.S => include/debug/ks8695.S}      | 10 +++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)
 rename arch/arm/{mach-ks8695/include/mach/debug-macro.S => include/debug/ks8695.S} (80%)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 6ee9b0d361ee..eba36e35bad2 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -397,6 +397,13 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to UART1 serial port on KEYSTONE2 devices.
 
+	config DEBUG_KS8695_UART
+		bool "KS8695 Debug UART"
+		depends on ARCH_KS8695
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on KS8695.
+
 	config DEBUG_MESON_UARTAO
 		bool "Kernel low-level debugging via Meson6 UARTAO"
 		depends on ARCH_MESON
@@ -1174,6 +1181,7 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX6Q_UART || \
 				 DEBUG_IMX6SL_UART || \
 				 DEBUG_IMX6SX_UART
+	default "debug/ks8695.S" if DEBUG_KS8695_UART
 	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 	default "debug/renesas-scif.S" if DEBUG_R7S72100_SCIF2
diff --git a/arch/arm/mach-ks8695/include/mach/debug-macro.S b/arch/arm/include/debug/ks8695.S
similarity index 80%
rename from arch/arm/mach-ks8695/include/mach/debug-macro.S
rename to arch/arm/include/debug/ks8695.S
index a79e48981202..961da1f32ab3 100644
--- a/arch/arm/mach-ks8695/include/mach/debug-macro.S
+++ b/arch/arm/include/debug/ks8695.S
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-ks8695/include/mach/debug-macro.S
+ * arch/arm/include/debug/ks8695.S
  *
  * Copyright (C) 2006 Ben Dooks <ben@simtec.co.uk>
  * Copyright (C) 2006 Simtec Electronics
@@ -11,8 +11,12 @@
  * published by the Free Software Foundation.
  */
 
-#include <mach/hardware.h>
-#include <mach/regs-uart.h>
+#define KS8695_UART_PA	0x03ffe000
+#define KS8695_UART_VA	0xf00fe000
+#define KS8695_URTH	(0x04)
+#define KS8695_URLS	(0x14)
+#define URLS_URTE	(1 << 6)
+#define URLS_URTHRE	(1 << 5)
 
 	.macro	addruart, rp, rv, tmp
 		ldr	\rp, =KS8695_UART_PA		@ physical base address
-- 
1.9.3

