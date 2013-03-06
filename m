Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab3CFKj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:39:29 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:59393 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757107Ab3CFKj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:39:27 -0500
Message-ID: <1362566365.16460.173.camel@x61.thuisdomein>
Subject: [PATCH] ARM: EXYNOS: change HAVE_SAMSUNG_KEYPAD to KEYBOARD_SAMSUNG
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 06 Mar 2013 11:39:25 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2013 10:39:25.0628 (UTC) FILETIME=[DF4E3FC0:01CE1A56]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6b5ab4f442e32f248b6fad29aafd1d5153f4dbd3 ("ARM: EXYNOS: Add
Exynos4 device tree enabled board file") added
	select HAVE_SAMSUNG_KEYPAD if INPUT_KEYBOARD

to the MACH_EXYNOS4_DT Kconfig entry. But there's no Kconfig symbol
HAVE_SAMSUNG_KEYPAD. Since this select statement depends on
INPUT_KEYBOARD this entry should select KEYBOARD_SAMSUNG instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "git grep" only.

1) Perhaps the fact that the symbol KEYBOARD_SAMSUNG enables a driver
called samsung-keypad caused confusion here. Anyhow, my choice for
KEYBOARD_SAMSUNG is only educated guesswork.

 arch/arm/mach-exynos/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 6c2bdc3..068aeb5 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -403,7 +403,7 @@ config MACH_EXYNOS4_DT
 	depends on ARCH_EXYNOS4
 	select ARM_AMBA
 	select CPU_EXYNOS4210
-	select HAVE_SAMSUNG_KEYPAD if INPUT_KEYBOARD
+	select KEYBOARD_SAMSUNG if INPUT_KEYBOARD
 	select PINCTRL
 	select PINCTRL_EXYNOS
 	select USE_OF
-- 
1.7.11.7

