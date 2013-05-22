Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3EVHLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:11:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45680 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3EVHLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:11:01 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 05/11] ARM: davinci: creation of gpio platform device for dm platforms
Date: Wed, 22 May 2013 12:40:28 +0530
Message-ID: <1369206634-6778-6-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio controller resource information being associated with
davinci_soc_info structure and not created any device. Hence davinci
gpio didn't fall under proper device model. This patch creates gpio
davinci as a platform device for dm platforms.
Also add daivinci_register_gpio API to create platform device for dm*
platforms.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/mach-davinci/devices.c             |   13 +++++++++++++
 arch/arm/mach-davinci/include/mach/common.h |    2 ++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index a7068a3..b4f345b 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -313,6 +313,19 @@ static void davinci_init_wdt(void)
 	platform_device_register(&davinci_wdt_device);
 }
 
+static struct platform_device davinci_gpio_device = {
+	.name		= "davinci_gpio",
+	.id		= -1,
+};
+
+int davinci_gpio_register(struct resource *res, int size, void *pdata)
+{
+	davinci_gpio_device.resource = res;
+	davinci_gpio_device.num_resources = size;
+	davinci_gpio_device.dev.platform_data = pdata;
+	return platform_device_register(&davinci_gpio_device);
+}
+
 /*-------------------------------------------------------------------------*/
 
 /*-------------------------------------------------------------------------*/
diff --git a/arch/arm/mach-davinci/include/mach/common.h b/arch/arm/mach-davinci/include/mach/common.h
index b124b77..bd389ba 100644
--- a/arch/arm/mach-davinci/include/mach/common.h
+++ b/arch/arm/mach-davinci/include/mach/common.h
@@ -14,6 +14,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/ioport.h>
 
 extern void davinci_timer_init(void);
 
@@ -83,6 +84,7 @@ extern void davinci_common_init(struct davinci_soc_info *soc_info);
 extern void davinci_init_ide(void);
 void davinci_restart(char mode, const char *cmd);
 void davinci_init_late(void);
+int davinci_gpio_register(struct resource *res, int size, void *pdata);
 
 #ifdef CONFIG_DAVINCI_RESET_CLOCKS
 int davinci_clk_disable_unused(void);
-- 
1.7.9.5

