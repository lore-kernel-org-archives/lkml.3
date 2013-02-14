Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428Ab3BNNw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:52:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934319Ab3BNNtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:49:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/11] ARM: pick Versatile by default for !MMU
Date: Thu, 14 Feb 2013 14:49:24 +0100
Message-Id: <1360849767-1463135-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QNgpG7aIQqp0zlg3SslTd93TAH37AZcEiX43e2lY62K
 CrkJsT/xR8kz/VGOy5i9fFHc1GoCBkT5O5OwWy1U3I2MqAwhcX
 6cQkNbjSgRwmsH/Xcz5v2USyh/QH//A77XUfNKNo6eQ2HiEXuK
 /5Sw7P6jYLiUg0RWkXzZrrZGQLBiW5369DImHszVvWbjIfjeWL
 3Fs2qZHDzwWPi1sfjbi/WTegk7PXDT97Yc2cSztoQntLKynv2/
 j2w70IzIbeVa/pkJBbu4JGlaY91s3fjybuqgJkEgdLptjOQ/Jb
 pMKODzrdC5BZLUfMkMZiF9wJ+nMZEWL9bI3GMsjKmaGTjhpTZl
 BaJUmYKXic+FLEZtOZZpIQ0dZzr7lZqk8I1YDyNNq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of ARCH_MULTIPLATFORM changed
the default for nommu kernels from Versatile to
Integrator, which is less common, and does not
currently build for allnoconfig because that does
not select any of the CPUs.

This also ensures that at least one of the three
board files in versatile are enabled, which lets
us successfully build an allnoconfig kernel.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig                | 3 ++-
 arch/arm/mach-versatile/Kconfig | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 91d4aea..b934d90 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -261,7 +261,8 @@ config MMU
 #
 choice
 	prompt "ARM system type"
-	default ARCH_MULTIPLATFORM
+	default ARCH_VERSATILE if !MMU
+	default ARCH_MULTIPLATFORM if MMU
 
 config ARCH_MULTIPLATFORM
 	bool "Allow multiple platforms to be selected"
diff --git a/arch/arm/mach-versatile/Kconfig b/arch/arm/mach-versatile/Kconfig
index 63d8e9f..1dba368 100644
--- a/arch/arm/mach-versatile/Kconfig
+++ b/arch/arm/mach-versatile/Kconfig
@@ -25,4 +25,9 @@ config MACH_VERSATILE_DT
 	  Include support for the ARM(R) Versatile/PB platform,
 	  using the device tree for discovery
 
+config MACH_VERSATILE_AUTO
+	def_bool y
+	depends on !ARCH_VERSATILE_PB && !MACH_VERSATILE_AB
+	select MACH_VERSATILE_DT
+
 endmenu
-- 
1.8.1.2

