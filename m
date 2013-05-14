Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab3ENQ5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:57:41 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:53592 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757891Ab3ENQ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:57:38 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <v-stehle@ti.com>
Subject: [PATCH] ARM: OMAP5: select SCU
Date: Tue, 14 May 2013 18:57:18 +0200
Message-Id: <1368550638-2046-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Stehlé <v-stehle@ti.com>

OMAP5 needs SCU in SMP.

This fixes the following link errors:

  arch/arm/mach-omap2/built-in.o: In function `scu_gp_set':
  arch/arm/mach-omap2/sleep44xx.S:132: undefined reference to `scu_power_mode'
  arch/arm/mach-omap2/built-in.o: In function `scu_gp_clear':
  arch/arm/mach-omap2/sleep44xx.S:229: undefined reference to `scu_power_mode'
  arch/arm/mach-omap2/built-in.o: In function `omap4_smp_prepare_cpus':
  arch/arm/mach-omap2/omap-smp.c:211: undefined reference to `scu_enable'
  arch/arm/mach-omap2/built-in.o: In function `omap4_smp_init_cpus':
  arch/arm/mach-omap2/omap-smp.c:185: undefined reference to `scu_get_core_count'

Signed-off-by: Vincent Stehlé <v-stehle@ti.com>
---
 arch/arm/mach-omap2/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index f49cd51..81690a2 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -109,6 +109,7 @@ config SOC_OMAP5
 	select ARM_CPU_SUSPEND if PM
 	select ARM_GIC
 	select CPU_V7
+	select HAVE_ARM_SCU if SMP
 	select HAVE_SMP
 	select COMMON_CLK
 	select HAVE_ARM_ARCH_TIMER
-- 
1.7.10.4

