Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaG2OZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:25:41 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61222 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbaG2OZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:25:39 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra: Move AHB Kconfig to drivers/amba
Date: Tue, 29 Jul 2014 16:25:34 +0200
Message-Id: <1406643934-16301-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This will allow the Kconfig option to be shared among 32-bit and 64-bit
ARM.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig |  8 --------
 drivers/amba/Kconfig        | 11 +++++++++++
 2 files changed, 11 insertions(+), 8 deletions(-)
 create mode 100644 drivers/amba/Kconfig

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 052fba07a3cb..fae2eb2f52ea 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -64,12 +64,4 @@ config ARCH_TEGRA_124_SOC
 	  Support for NVIDIA Tegra T124 processor family, based on the
 	  ARM CortexA15MP CPU
 
-config TEGRA_AHB
-	bool "Enable AHB driver for NVIDIA Tegra SoCs"
-	default y
-	help
-	  Adds AHB configuration functionality for NVIDIA Tegra SoCs,
-	  which controls AHB bus master arbitration and some
-	  performance parameters(priority, prefech size).
-
 endif
diff --git a/drivers/amba/Kconfig b/drivers/amba/Kconfig
new file mode 100644
index 000000000000..3f7350a03708
--- /dev/null
+++ b/drivers/amba/Kconfig
@@ -0,0 +1,11 @@
+if ARM_AMBA
+
+config TEGRA_AHB
+	bool "Enable AHB driver for NVIDIA Tegra SoCs"
+	default y if ARCH_TEGRA
+	help
+	  Adds AHB configuration functionality for NVIDIA Tegra SoCs,
+	  which controls AHB bus master arbitration and some performance
+	  parameters (priority, prefetch size).
+
+endif
-- 
2.0.2

