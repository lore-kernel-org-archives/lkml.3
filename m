Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaIOOJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:09:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:32865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbaIOOJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:09:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,528,1406617200"; 
   d="scan'208";a="599766311"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>,
        Ning Li <ning.li@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] gpio: Increase ARCH_NR_GPIOs to 512
Date: Mon, 15 Sep 2014 17:09:44 +0300
Message-Id: <1410790185-31101-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some newer Intel SoCs, like Braswell already have more than 256 GPIOs
available so the default limit is exceeded. Instead of adding more
architecture specific gpio.h files with custom ARCH_NR_GPIOs we increase
the gpiolib default limit to be twice the current.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changes to previous version is that now we increase the common limit
instead of adding x86 specific gpio.h

 include/asm-generic/gpio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index c1d4105e1c1d..383ade1a211b 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -27,7 +27,7 @@
  */
 
 #ifndef ARCH_NR_GPIOS
-#define ARCH_NR_GPIOS		256
+#define ARCH_NR_GPIOS		512
 #endif
 
 /*
-- 
2.1.0

