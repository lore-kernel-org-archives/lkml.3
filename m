Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3FNJ4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:56:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38102 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab3FNJ4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:56:36 -0400
From: Philip Avinash <avinashphilipk@gmail.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Philip Avinash <avinashphilipk@gmail.com>
Subject: [PATCH 2/2] gpio: gpio-tnetv107x: Fix bulid breakge
Date: Fri, 14 Jun 2013 15:27:49 +0530
Message-ID: <1371203869-16308-3-git-send-email-avinashphilipk@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com>
References: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

includes linux/io.h for fixing following build error. This build error
comes only after removing select option of NEED_MACH_GPIO_H for
ARCH_DAVINCI. linux/io.h is got included from mach/gpio-davinci.h on
selection of NEED_MACH_GPIO_H.

drivers/gpio/gpio-tnetv107x.c: In function 'tnetv107x_gpio_request':
drivers/gpio/gpio-tnetv107x.c:63:2: error: implicit declaration of
function '__raw_writel'
drivers/gpio/gpio-tnetv107x.c:63:2: error: implicit declaration of
function '__raw_readl'
drivers/gpio/gpio-tnetv107x.c: In function 'tnetv107x_gpio_setup':
drivers/gpio/gpio-tnetv107x.c:172:2: error: implicit declaration of
function 'ioremap'
drivers/gpio/gpio-tnetv107x.c:172:7: warning: assignment makes pointer
from integer without a cast

Signed-off-by: Philip Avinash <avinashphilipk@gmail.com>
---
 drivers/gpio/gpio-tnetv107x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-tnetv107x.c b/drivers/gpio/gpio-tnetv107x.c
index 3fa3e28..c7ed335 100644
--- a/drivers/gpio/gpio-tnetv107x.c
+++ b/drivers/gpio/gpio-tnetv107x.c
@@ -14,6 +14,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/gpio.h>
 
 #include <mach/common.h>
-- 
1.7.9.5

