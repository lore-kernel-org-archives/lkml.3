Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaIKMGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:06:24 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:37175 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaIKMGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:06:22 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de
Cc: festevam@gmail.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH 2/2] ARM: vf610: Use ARM Global Timer as clocksource
Date: Thu, 11 Sep 2014 14:06:15 +0200
Message-Id: <1410437175-6636-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410437175-6636-1-git-send-email-stefan@agner.ch>
References: <1410437175-6636-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ARM Global Timer as clocksource instead of the PIT timer. This
leaves the PIT timer for other users e.g. the secondary Cortex-M4
core. Also, the Global Timer has double the precission (running at
pheripheral clock compared to IPG clock) and a 64-bit incrementing
counter register.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
Theoretically we could remove the PIT driver now. But we could also
enable both drivers, but is having two clock source useful for the
Kernel at all?

 arch/arm/mach-imx/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 64161aa..adc77180 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -656,7 +656,8 @@ config SOC_VF610
 	bool "Vybrid Family VF610 support"
 	select ARM_GIC
 	select PINCTRL_VF610
-	select VF_PIT_TIMER
+	select ARM_GLOBAL_TIMER
+	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
 	select PL310_ERRATA_769419 if CACHE_L2X0
 
 	help
-- 
2.1.0

