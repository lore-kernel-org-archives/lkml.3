Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3G2V3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:29:22 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47738 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3G2V3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:29:20 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: ralf@linux-mips.org, linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2 1/2] MIPS: OCTEON: Select ARCH_REQUIRE_GPIOLIB
Date: Mon, 29 Jul 2013 14:29:09 -0700
Message-Id: <1375133350-18828-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
References: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

... and create asm/mach-cavium-octeon/gpio.h so that things continue
to build.

This allows us to use the existing I2C connected GPIO expanders.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/Kconfig                               |  1 +
 arch/mips/include/asm/mach-cavium-octeon/gpio.h | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/gpio.h

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index c3abed3..9c2293a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -731,6 +731,7 @@ config CAVIUM_OCTEON_SOC
 	select USB_ARCH_HAS_OHCI
 	select USB_ARCH_HAS_EHCI
 	select HOLES_IN_ZONE
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  This option supports all of the Octeon reference boards from Cavium
 	  Networks. It builds a kernel that dynamically determines the Octeon
diff --git a/arch/mips/include/asm/mach-cavium-octeon/gpio.h b/arch/mips/include/asm/mach-cavium-octeon/gpio.h
new file mode 100644
index 0000000..34e9f7a
--- /dev/null
+++ b/arch/mips/include/asm/mach-cavium-octeon/gpio.h
@@ -0,0 +1,21 @@
+#ifndef __ASM_MACH_CAVIUM_OCTEON_GPIO_H
+#define __ASM_MACH_CAVIUM_OCTEON_GPIO_H
+
+#ifdef CONFIG_GPIOLIB
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
+#else
+int gpio_request(unsigned gpio, const char *label);
+void gpio_free(unsigned gpio);
+int gpio_direction_input(unsigned gpio);
+int gpio_direction_output(unsigned gpio, int value);
+int gpio_get_value(unsigned gpio);
+void gpio_set_value(unsigned gpio, int value);
+#endif
+
+#include <asm-generic/gpio.h>
+
+#define gpio_to_irq	__gpio_to_irq
+
+#endif /* __ASM_MACH_GENERIC_GPIO_H */
-- 
1.7.11.7

