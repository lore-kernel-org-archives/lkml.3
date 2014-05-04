Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbaEDQ56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:57:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaEDPlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrea Adami <andrea.adami@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.14 021/158] ARM: pxa: hx4700.h: include "irqs.h" for PXA_NR_BUILTIN_GPIO
Date: Sun,  4 May 2014 11:38:50 -0400
Message-Id: <20140504154032.910009991@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Adami <andrea.adami@gmail.com>

commit c02b50e90be9f41d6802049a1a08246e9eb1a22c upstream.

hx4700 needs the same fix as in
9705e74671f0e4f994d86b00cecf441917c64a66
"ARM: pxa: fix various compilation problems"

Fix build errors. Initial one is:
/linux/arch/arm/mach-pxa/include/mach/hx4700.h:18:32: error:
 'PXA_NR_BUILTIN_GPIO' undeclared here (not in a function)
|  #define HX4700_ASIC3_GPIO_BASE PXA_NR_BUILTIN_GPIO

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-pxa/include/mach/hx4700.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-pxa/include/mach/hx4700.h
+++ b/arch/arm/mach-pxa/include/mach/hx4700.h
@@ -14,6 +14,7 @@
 
 #include <linux/gpio.h>
 #include <linux/mfd/asic3.h>
+#include "irqs.h" /* PXA_NR_BUILTIN_GPIO */
 
 #define HX4700_ASIC3_GPIO_BASE	PXA_NR_BUILTIN_GPIO
 #define HX4700_EGPIO_BASE	(HX4700_ASIC3_GPIO_BASE + ASIC3_NUM_GPIOS)


