Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaFJUbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:31:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35001 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbaFJTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrea Adami <andrea.adami@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 083/160] ARM: pxa: hx4700.h: include "irqs.h" for PXA_NR_BUILTIN_GPIO
Date: Tue, 10 Jun 2014 12:45:23 -0700
Message-Id: <1402429600-20477-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-pxa/include/mach/hx4700.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-pxa/include/mach/hx4700.h b/arch/arm/mach-pxa/include/mach/hx4700.h
index 8bc0291..0e1bb46 100644
--- a/arch/arm/mach-pxa/include/mach/hx4700.h
+++ b/arch/arm/mach-pxa/include/mach/hx4700.h
@@ -14,6 +14,7 @@
 
 #include <linux/gpio.h>
 #include <linux/mfd/asic3.h>
+#include "irqs.h" /* PXA_NR_BUILTIN_GPIO */
 
 #define HX4700_ASIC3_GPIO_BASE	PXA_NR_BUILTIN_GPIO
 #define HX4700_EGPIO_BASE	(HX4700_ASIC3_GPIO_BASE + ASIC3_NUM_GPIOS)
-- 
1.9.1

