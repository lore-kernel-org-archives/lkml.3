Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaAUVet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:34:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50756 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaAUVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:26 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 17/73] arm: fix implicit module.h use in mach-at91 gpio.h
Date: Tue, 21 Jan 2014 16:22:20 -0500
Message-ID: <1390339396-3479-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently get __init_or_module from init.h (implicitly) but if
we move that to module.h we will get failures like this:

In file included from /home/paul/git/linux-head/arch/arm/include/asm/gpio.h:10:0,
                 from include/linux/gpio.h:48,
                 from include/linux/of_gpio.h:20,
                 from drivers/input/touchscreen/ads7846.c:30:
arch/arm/mach-at91/include/mach/gpio.h:191:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_GPIO_periph'
arch/arm/mach-at91/include/mach/gpio.h:192:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_A_periph'
arch/arm/mach-at91/include/mach/gpio.h:193:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_B_periph'
arch/arm/mach-at91/include/mach/gpio.h:194:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_C_periph'
arch/arm/mach-at91/include/mach/gpio.h:195:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_D_periph'
arch/arm/mach-at91/include/mach/gpio.h:196:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_gpio_input'
arch/arm/mach-at91/include/mach/gpio.h:197:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_gpio_output'
arch/arm/mach-at91/include/mach/gpio.h:198:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_deglitch'
arch/arm/mach-at91/include/mach/gpio.h:199:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_debounce'
arch/arm/mach-at91/include/mach/gpio.h:200:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_multi_drive'
arch/arm/mach-at91/include/mach/gpio.h:201:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_set_pulldown'
arch/arm/mach-at91/include/mach/gpio.h:202:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'at91_disable_schmitt_trig'
make[3]: *** [drivers/input/touchscreen/ads7846.o] Error 1

Fix it up in advance by including module.h explicitly.

Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/mach-at91/include/mach/gpio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/include/mach/gpio.h b/arch/arm/mach-at91/include/mach/gpio.h
index 5fc2377..78abd64 100644
--- a/arch/arm/mach-at91/include/mach/gpio.h
+++ b/arch/arm/mach-at91/include/mach/gpio.h
@@ -14,6 +14,7 @@
 #define __ASM_ARCH_AT91RM9200_GPIO_H
 
 #include <linux/kernel.h>
+#include <linux/module.h>	/* for __init_or_module */
 #include <asm/irq.h>
 
 #define MAX_GPIO_BANKS		5
-- 
1.8.4.1

