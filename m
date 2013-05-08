Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3EHSw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:52:58 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:38539 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3EHSw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:52:56 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: exynos: Select PINCTRL_EXYNOS for exynos4/5 at arch level
Date: Wed,  8 May 2013 11:52:48 -0700
Message-Id: <1368039168-24447-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368034349-15091-1-git-send-email-dianders@chromium.org>
References: <1368034349-15091-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously if you had MACH_EXYNOS5_DT but not MACH_EXYNOS4_DT you'd be
missing the pincontrol definitions.  Move PINCTRL selects to the arch
level since we should be enabling the code for all exynos variants.

It's expected that eventually exynos5440 (which seems to have its own
pinctrl code) will eventually move over to the common code.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Moved to the arch level as suggested by Olof.

 arch/arm/mach-exynos/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 6e77432..7ee58b0 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -17,6 +17,8 @@ config ARCH_EXYNOS4
 	select HAVE_ARM_SCU if SMP
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
+	select PINCTRL
+	select PINCTRL_EXYNOS
 	help
 	  Samsung EXYNOS4 SoCs based systems
 
@@ -24,6 +26,8 @@ config ARCH_EXYNOS5
 	bool "SAMSUNG EXYNOS5"
 	select HAVE_ARM_SCU if SMP
 	select HAVE_SMP
+	select PINCTRL
+	select PINCTRL_EXYNOS
 	help
 	  Samsung EXYNOS5 (Cortex-A15) SoC based systems
 
@@ -78,7 +82,6 @@ config SOC_EXYNOS5440
 	select ARCH_HAS_OPP
 	select ARM_ARCH_TIMER
 	select AUTO_ZRELADDR
-	select PINCTRL
 	select PINCTRL_EXYNOS5440
 	select PM_OPP
 	help
@@ -412,8 +415,6 @@ config MACH_EXYNOS4_DT
 	select CLKSRC_OF
 	select CPU_EXYNOS4210
 	select KEYBOARD_SAMSUNG if INPUT_KEYBOARD
-	select PINCTRL
-	select PINCTRL_EXYNOS
 	select S5P_DEV_MFC
 	select USE_OF
 	help
-- 
1.8.2.1

