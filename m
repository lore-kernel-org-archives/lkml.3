Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaLJNWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:22:21 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:43134 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbaLJNV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:21:58 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 3/3] gpio/xilinx: Add support for X86 Arch
Date: Wed, 10 Dec 2014 14:21:50 +0100
Message-Id: <1418217710-11987-4-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418217710-11987-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1418217710-11987-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core can be accessed via PCIe on X86 platform.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

v2: Minor change on title

 drivers/gpio/Kconfig       | 4 ++--
 drivers/gpio/gpio-xilinx.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0959ca9..7f8ba83 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -343,8 +343,8 @@ config GPIO_XGENE
 	  here to enable the GFC GPIO functionality.
 
 config GPIO_XILINX
-	bool "Xilinx GPIO support"
-	depends on PPC_OF || MICROBLAZE || ARCH_ZYNQ
+	tristate "Xilinx GPIO support"
+	depends on OF_GPIO && (PPC_OF || MICROBLAZE || ARCH_ZYNQ || ARCH_X86)
 	help
 	  Say yes here to support the Xilinx FPGA GPIO device
 
diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index f946d96..5463540 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -30,7 +30,7 @@
 #define XGPIO_CHANNEL_OFFSET	0x8
 
 /* Read/Write access to the GPIO registers */
-#ifdef CONFIG_ARCH_ZYNQ
+#if defined(CONFIG_ARCH_ZYNQ) || defined(CONFIG_X86)
 # define xgpio_readreg(offset)		readl(offset)
 # define xgpio_writereg(offset, val)	writel(val, offset)
 #else
-- 
2.1.3

