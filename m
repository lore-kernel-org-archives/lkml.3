Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3DWQbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:31:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab3DWQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:31:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 05/21] ARM: OMAP2+: add dependencies on ARCH_MULTI_V6/V7
Date: Tue, 23 Apr 2013 18:30:37 +0200
Message-Id: <1366734653-488286-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:r46ZhM2vemnvqNEt5IFC3kvGttOjzvA43EHCKwGAN6w
 Y8OhzEtncjPiiC4q9kJEataZCIfw30MLG4/wqUYtzrpmvl/+Qi
 /Az4xV9mIRSMk2jr7C9Owz55bVooqmEwF19FwlGAGeJJjigeBE
 n9IZneCg5RLJPY7UUXPpLyf6reqg4IYDFrfPaSp22LCT2s8dyy
 KzaGuZUBq01aZtq5hOhzOWckzAe/crZcy1VjybbaI2BRa5hL1L
 p+8UCpCLMhfkBnM5/2BXwPUlKhFtqkZai5NbPllJM2+aMIJMXj
 /5cNAjIU7hceqgW1KuxIkvwnoYVIgysnnAZCUwkvqj5cxHbWmQ
 //geqjcpRxn7Oxvwvht4Yj+5LYuXQjXTq2SRElDZm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_ARCH_OMAP2PLUS depends on (ARCH_MULTI_V6 || ARCH_MULTI_V7) as of
a0694861 "ARM: OMAP2+: Enable ARCH_MULTIPLATFORM support", but the
individual OMAP2/3/4/5 and AM33XX platforms can all be selected independent
of what we are building for, which is a bug and prevents us from easily
building e.g. an ARMv7-only defconfig.

This makes ARCH_OMAP2 depend on ARCH_MULTI_V6 and the others depend on
ARCH_MULTI_V7, to ensure we really only build the platforms for the
CPUs we have enabled in the global multiplatform configuration step.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 8111cd9..552341d 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -55,6 +55,7 @@ config SOC_HAS_REALTIME_COUNTER
 config ARCH_OMAP2
 	bool "TI OMAP2"
 	depends on ARCH_OMAP2PLUS
+	depends on ARCH_MULTI_V6
 	default y
 	select CPU_V6
 	select MULTI_IRQ_HANDLER
@@ -64,6 +65,7 @@ config ARCH_OMAP2
 config ARCH_OMAP3
 	bool "TI OMAP3"
 	depends on ARCH_OMAP2PLUS
+	depends on ARCH_MULTI_V7
 	default y
 	select ARCH_HAS_OPP
 	select ARM_CPU_SUSPEND if PM
@@ -80,6 +82,7 @@ config ARCH_OMAP4
 	bool "TI OMAP4"
 	default y
 	depends on ARCH_OMAP2PLUS
+	depends on ARCH_MULTI_V7
 	select ARCH_HAS_OPP
 	select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
 	select ARM_CPU_SUSPEND if PM
@@ -99,6 +102,7 @@ config ARCH_OMAP4
 
 config SOC_OMAP5
 	bool "TI OMAP5"
+	depends on ARCH_MULTI_V7
 	select ARM_CPU_SUSPEND if PM
 	select ARM_GIC
 	select CPU_V7
@@ -135,6 +139,7 @@ config SOC_TI81XX
 
 config SOC_AM33XX
 	bool "AM33XX support"
+	depends on ARCH_MULTI_V7
 	default y
 	select ARM_CPU_SUSPEND if PM
 	select CPU_V7
-- 
1.8.1.2

