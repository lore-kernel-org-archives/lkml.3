Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3BCLZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:25:06 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:33721 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3BCLZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:25:00 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: multiplatform: Sort the max gpio numbers.
Date: Sun,  3 Feb 2013 12:24:48 +0100
Message-Id: <1359890688-10336-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a multiplatform kernel, we could end up with a smaller
number of GPIOs than the one required by the platform the kernel was
running on.

Sort the max GPIO number by descending order so that we always take the
highest number required.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/Kconfig |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1e86fa9..852ae76 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1626,13 +1626,16 @@ config LOCAL_TIMERS
 	  accounting to be spread across the timer interval, preventing a
 	  "thundering herd" at every timer tick.
 
+# The GPIO number here must be sorted by descending number. In case of
+# a multiplatform kernel, we just want the highest value required by the
+# selected platforms.
 config ARCH_NR_GPIO
 	int
 	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
-	default 355 if ARCH_U8500
-	default 264 if MACH_H4700
 	default 512 if SOC_OMAP5
+	default 355 if ARCH_U8500
 	default 288 if ARCH_VT8500 || ARCH_SUNXI
+	default 264 if MACH_H4700
 	default 0
 	help
 	  Maximum number of GPIOs in the system.
-- 
1.7.10.4

