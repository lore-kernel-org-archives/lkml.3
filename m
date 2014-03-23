Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaCWTgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:36:25 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:48880 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaCWTgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:36:23 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] ARM: shmobile: r8a7778/bockw: Move "select RENESAS_INTC_IRQPIN" under SoC
Date: Sun, 23 Mar 2014 20:36:18 +0100
Message-Id: <1395603378-32199-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Move the "select RENESAS_INTC_IRQPIN" from the two bockw-specific sections
to the one r8a7778-specific section, like is done for the other SoCs.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 arch/arm/mach-shmobile/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index edf61e5c1b7b..75ccebfa16a3 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -102,6 +102,7 @@ config ARCH_R8A7778
 	select ARM_GIC
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
+	select RENESAS_INTC_IRQPIN
 
 config ARCH_R8A7779
 	bool "R-Car H1 (R8A77790)"
@@ -198,7 +199,6 @@ config MACH_BOCKW
 	depends on ARCH_R8A7778
 	select ARCH_REQUIRE_GPIOLIB
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
-	select RENESAS_INTC_IRQPIN
 	select SND_SOC_AK4554 if SND_SIMPLE_CARD
 	select SND_SOC_AK4642 if SND_SIMPLE_CARD
 	select USE_OF
@@ -207,7 +207,6 @@ config MACH_BOCKW_REFERENCE
 	bool "BOCK-W  - Reference Device Tree Implementation"
 	depends on ARCH_R8A7778
 	select ARCH_REQUIRE_GPIOLIB
-	select RENESAS_INTC_IRQPIN
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	select USE_OF
 	---help---
-- 
1.7.9.5

