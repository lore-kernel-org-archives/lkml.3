Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937424Ab3DKANq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:13:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937308Ab3DKAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/30] ARM: exynos: introduce EXYNOS_ATAGS symbol
Date: Thu, 11 Apr 2013 02:04:43 +0200
Message-Id: <1365638712-1028578-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ZP+iKcH/agJTyFrVwuloD/ItdliPm+/BSC+1Cl6Uipc
 Bh04aTqrmDMcjRUTp07E07Pa9Df2woIJvKWTyz/v9LmZ6nrg2h
 34hEhcgz7qTqYJ/4cw5ObSJFa1fS/3Fgw9sMGog0zb/GUU1/sr
 rEQhRrzRTyJCzp0Ftr2WMjUy1uj9aXPlvmWE/Dzfozq/g9gY6c
 y7/rm498DQIccmtDIMdven20Aj/nxg3fWIeCH7HsVcTU7VQ9uJ
 cMgPKj6gZi/5FoE44PWHPVh+dpiAvsYbfajmglNgTw56tMJLOn
 K+T0kBX3ixdxX9EKc2I2PdERuo4HjL1P5vFQpgJqI5lbKEhqLX
 C+4FFubJz3IaZqtg9u2Z/I66/73YSAYYgo2LNmrOf2GP0P2KyO
 biZuRszN3SRXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for multiplatform support, this introduces
a new Kconfig symbol to split the ATAGS based EXYNOS platforms
from the DT based ones. Turning off CONFIG_EXYNOS_ATAGS disables
all platforms that are not yet converted to DT, and we can
have code that relies on DT checking for this symbol being
disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-exynos/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index a62cfa0..e815057 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -82,6 +82,19 @@ config SOC_EXYNOS5440
 	help
 	  Enable EXYNOS5440 SoC support
 
+config EXYNOS_ATAGS
+	bool "ATAGS based boot for EXYNOS (deprecated)"
+	depends on ARCH_EXYNOS_SINGLE
+	depends on ATAGS
+	default y
+	help
+	  The EXYNOS platform is moving towards being completely probed
+	  through device tree. This enables support for board files using
+	  the traditional ATAGS boot format.
+	  Note that this option is not available for multiplatform builds.
+
+if EXYNOS_ATAGS
+
 config EXYNOS_DEV_DMA
 	bool
 	help
@@ -386,6 +399,8 @@ config MACH_SMDK4412
 	  Machine support for Samsung SMDK4412
 endif
 
+endif
+
 comment "Flattened Device Tree based board for EXYNOS SoCs"
 
 config MACH_EXYNOS4_DT
-- 
1.8.1.2

