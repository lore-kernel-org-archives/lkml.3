Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3H2J6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:58:08 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3206 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3H2J6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:58:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 29 Aug 2013 02:55:29 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>
CC: <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 2/5] ARM: tegra: add support for Trusted Foundations
Date: Thu, 29 Aug 2013 18:57:45 +0900
Message-ID: <1377770268-14014-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1377770268-14014-1-git-send-email-acourbot@nvidia.com>
References: <1377770268-14014-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the firmware operations for Trusted Foundations if the device
tree indicates it is active on the device.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/devicetree/bindings/arm/tegra.txt | 5 +++++
 arch/arm/mach-tegra/Kconfig                     | 1 +
 arch/arm/mach-tegra/common.c                    | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/tegra.txt b/Documentation/devicetree/bindings/arm/tegra.txt
index ed9c853..5423f51 100644
--- a/Documentation/devicetree/bindings/arm/tegra.txt
+++ b/Documentation/devicetree/bindings/arm/tegra.txt
@@ -32,3 +32,8 @@ board-specific compatible values:
   nvidia,whistler
   toradex,colibri_t20-512
   toradex,iris
+
+Trusted Foundations
+-------------------------------------------
+Tegra supports the Trusted Foundation secure monitor. See the
+"tl,trusted-foundations" binding for more details.
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index ef3a8da..b6b7c44 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -2,6 +2,7 @@ config ARCH_TEGRA
 	bool "NVIDIA Tegra" if ARCH_MULTI_V7
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select CLKSRC_OF
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 94a119a..b405e45 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -27,6 +27,7 @@
 #include <linux/clk-provider.h>
 
 #include <asm/hardware/cache-l2x0.h>
+#include <asm/trusted_foundations.h>
 
 #include "board.h"
 #include "common.h"
@@ -99,6 +100,7 @@ static void __init tegra_init_cache(void)
 
 void __init tegra_init_early(void)
 {
+	of_register_trusted_foundations();
 	tegra_cpu_reset_handler_init();
 	tegra_apb_io_init();
 	tegra_init_fuse();
-- 
1.8.4

