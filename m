Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbbA2Jf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:35:28 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:37989 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbbA2JfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:35:24 -0500
Date: Thu, 29 Jan 2015 09:35:23 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
cc: Paul Walmsley <pwalmsley@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Paul Bolle <pebolle@tiscali.it>
Subject: [PATCH] arm64: Kconfig: clean up two no-op Kconfig options from
 CONFIG_ARCH_TEGRA*
Message-ID: <alpine.DEB.2.02.1501290928230.19947@utopia.booyaka.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul Bolle pointed out that commit
d035fdfa27ac124bc8f94c3d7dc82ad069802170 ("arm64: Add Tegra132
support") included two Kconfig symbols that are now no-ops:
USB_ARCH_HAS_EHCI and HAVE_SMP.  So, drop the two symbols.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Allen Martin <amartin@nvidia.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul Bolle <pebolle@tiscali.it>
---

Boot-tested on NVIDIA Tegra132 Norrin64 FFD with a extra DTS page for the 
board data (not yet posted upstream).

 arch/arm64/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3b97e725ebfc..ae18c3d2bb3b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -180,7 +180,6 @@ config ARCH_TEGRA
 	select CLKSRC_OF
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
-	select HAVE_SMP
 	select PINCTRL
 	select RESET_CONTROLLER
 	help
@@ -190,7 +189,6 @@ config ARCH_TEGRA_132_SOC
 	bool "NVIDIA Tegra132 SoC"
 	depends on ARCH_TEGRA
 	select PINCTRL_TEGRA124
-	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select USB_ULPI if USB_PHY
 	select USB_ULPI_VIEWPORT if USB_PHY
 	help
-- 
2.1.4

