Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3JKVpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:45:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7481 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3JKVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 17:45:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Oct 2013 14:41:33 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v8 2/5] ARM: tegra: add support for Trusted Foundations
Date: Fri, 11 Oct 2013 14:45:35 -0700
Message-ID: <1381527938-22840-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381527938-22840-1-git-send-email-acourbot@nvidia.com>
References: <1381527938-22840-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the firmware operations for Trusted Foundations if the device
tree indicates it is active on the device.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
 Documentation/devicetree/bindings/arm/tegra.txt | 5 +++++
 arch/arm/mach-tegra/Kconfig                     | 1 +
 arch/arm/mach-tegra/common.c                    | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/tegra.txt b/Documentation/devicetree/bindings/arm/tegra.txt
index ed9c853..8e51884 100644
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
+"tl,trusted-foundations" binding's documentation for more details.
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 67a76f2..4e51278 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -2,6 +2,7 @@ config ARCH_TEGRA
 	bool "NVIDIA Tegra" if ARCH_MULTI_V7
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
 	select ARM_GIC
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
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

