Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaIHLsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:48:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:54092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbaIHLsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:48:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,486,1406617200"; 
   d="scan'208";a="599620220"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH 1/2] x86, gpio: Increase ARCH_NR_GPIOs to 512
Date: Mon,  8 Sep 2014 14:47:59 +0300
Message-Id: <1410176880-22524-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some newer Intel SoCs like Braswell already have more than 256 GPIOs
available so the default limit is exceeded. In order to support these add
back the custom GPIO header with limit of 512 GPIOs for x86.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 arch/x86/Kconfig            |  1 +
 arch/x86/include/asm/gpio.h | 54 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 778178f4c7d1..0bf6fe76e7ba 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -136,6 +136,7 @@ config X86
 	select HAVE_ACPI_APEI if ACPI
 	select HAVE_ACPI_APEI_NMI if ACPI
 	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
+	select ARCH_HAVE_CUSTOM_GPIO_H
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/gpio.h b/arch/x86/include/asm/gpio.h
index b3799d88ffcf..152b71788f2d 100644
--- a/arch/x86/include/asm/gpio.h
+++ b/arch/x86/include/asm/gpio.h
@@ -1,4 +1,50 @@
-#ifndef __LINUX_GPIO_H
-#warning Include linux/gpio.h instead of asm/gpio.h
-#include <linux/gpio.h>
-#endif
+/*
+ * GPIO customization for x86.
+ *
+ * Based on the original code:
+ *
+ * Copyright (c) 2007-2008  MontaVista Software, Inc.
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * Copyright (c) 2014, Intel Corporation.
+ * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_X86_GPIO_H
+#define __ASM_X86_GPIO_H
+
+#define ARCH_NR_GPIOS 512
+#include <asm-generic/gpio.h>
+
+#ifdef CONFIG_GPIOLIB
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return __gpio_to_irq(gpio);
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_GPIOLIB */
+
+#endif /* __ASM_X86_GPIO_H */
-- 
2.1.0

