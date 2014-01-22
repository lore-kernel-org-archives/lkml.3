Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaAVALq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 19:11:46 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:28929 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaAVALn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 19:11:43 -0500
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="10560812"
From: Markus Mayer <markus.mayer@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linaro Patches <patches@linaro.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH] gpio: bcm281xx: Fix parameter name for GPIO_CONTROL macro
Date: Tue, 21 Jan 2014 16:10:04 -0800
Message-ID: <1390349404-23326-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO_CONTROL macro returns the control register offset when given a
GPIO number.

Update the argument name in the macro to reflect that it takes in a
GPIO number and not a bank.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/gpio/gpio-bcm-kona.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index 233d088..93a5b01 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -28,6 +28,10 @@
 #define GPIO_BANK(gpio)				((gpio) >> 5)
 #define GPIO_BIT(gpio)				((gpio) & (GPIO_PER_BANK - 1))
 
+/* There is a GPIO control register for each GPIO */
+#define GPIO_CONTROL(gpio)			(0x00000100 + ((gpio) << 2))
+
+/* The remaining registers are per GPIO bank */
 #define GPIO_OUT_STATUS(bank)			(0x00000000 + ((bank) << 2))
 #define GPIO_IN_STATUS(bank)			(0x00000020 + ((bank) << 2))
 #define GPIO_OUT_SET(bank)			(0x00000040 + ((bank) << 2))
@@ -35,7 +39,6 @@
 #define GPIO_INT_STATUS(bank)			(0x00000080 + ((bank) << 2))
 #define GPIO_INT_MASK(bank)			(0x000000a0 + ((bank) << 2))
 #define GPIO_INT_MSKCLR(bank)			(0x000000c0 + ((bank) << 2))
-#define GPIO_CONTROL(bank)			(0x00000100 + ((bank) << 2))
 #define GPIO_PWD_STATUS(bank)			(0x00000500 + ((bank) << 2))
 
 #define GPIO_GPPWR_OFFSET			0x00000520
-- 
1.7.9.5

