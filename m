Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3KUPkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:40:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47309 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab3KUPkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:40:33 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>
CC: <prabhakar.csengg@gmail.com>, <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 2/2] gpio: introduce GPIO_DAVINCI kconfig option
Date: Thu, 21 Nov 2013 17:34:36 +0200
Message-ID: <1385048076-7875-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385048076-7875-1-git-send-email-grygorii.strashko@ti.com>
References: <1385048076-7875-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compatible to Davinci GPIO HW block is used by other TI SoCs, like
Keystone, where GPIO support is declared as optional.

Hence, introduce GPIO_DAVINCI Kconfig option which will allow to enable
Davinci GPIO driver for Keystone SoCs when needed. At same time, kept
Davinci GPIO driver enabled for Davinci SoCs by default.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/gpio/Kconfig  |    7 +++++++
 drivers/gpio/Makefile |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0f04444..7c75f5a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -115,6 +115,13 @@ config GPIO_CLPS711X
 	help
 	  Say yes here to support GPIO on CLPS711X SoCs.
 
+config GPIO_DAVINCI
+	bool "TI Davinci/Keystone GPIO support"
+	default y if ARCH_DAVINCI
+	depends on ARM && (ARCH_DAVINCI || ARCH_KEYSTONE)
+	help
+	  Say yes here to enable GPIO support for TI Davinci/Keystone SoCs.
+
 config GPIO_GENERIC_PLATFORM
 	tristate "Generic memory-mapped GPIO controller support (MMIO platform device)"
 	select GPIO_GENERIC
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 7971e36..28a0ffc 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -22,7 +22,7 @@ obj-$(CONFIG_GPIO_CLPS711X)	+= gpio-clps711x.o
 obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
-obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
+obj-$(CONFIG_GPIO_DAVINCI)	+= gpio-davinci.o
 obj-$(CONFIG_GPIO_EM)		+= gpio-em.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_F7188X)	+= gpio-f7188x.o
-- 
1.7.9.5

