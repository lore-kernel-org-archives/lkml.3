Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3FYOTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:19:50 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:55160 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990Ab3FYOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:19:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH] pinctrl: elaborate a bit on arrangements in doc
Date: Tue, 25 Jun 2013 16:19:12 +0200
Message-ID: <1372169952-22439-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This elaborates a bit on the pinctrl vs GPIO arangements
in the hardware.

Inspired by some drawings in a mail from Christian
Ruppert.

Cc: Rob Landley <rob@landley.net>
Cc: Christian Ruppert <christian.ruppert@abilis.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 447fd4c..41ecad0 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -784,11 +784,38 @@ special GPIO-handler is registered.
 GPIO mode pitfalls
 ==================
 
-Sometime the developer may be confused by a datasheet talking about a pin
-being possible to set into "GPIO mode". It appears that what hardware
-engineers mean with "GPIO mode" is not necessarily the use case that is
-implied in the kernel interface <linux/gpio.h>: a pin that you grab from
-kernel code and then either listen for input or drive high/low to
+The GPIO portions of a pin and its relation to a certain pin controller
+logic can be constructed in several ways. Here are three examples:
+
+(A)
+
+                                         +- SPI
+     Physical pins --- GPIO --- pinctrl -+- I2C
+                                         +- mmc
+
+(B)
+                    +- GPIO
+     Physical pins -+           +- SPI
+                    +- pinctrl -+- I2C
+                                +- mmc
+
+(C)
+                                +- SPI
+     Physical pins --- pinctrl -+- I2C
+                                +- mmc
+                                +- GPIO
+
+In (A) the GPIO-like functionality of the pin is *always* available.
+For example it is possible to read the GPIO input register to "spy" on
+the SPI, I2C or MMC line while it is being used by the peripheral.
+In (B) the GPIO functionality is orthogonal to any device using the
+pin, and in (C) the GPIO case is the same as "some peripheral".
+
+For this reason the developer may be confused by a datasheet talking
+about a pin being possible to set into "GPIO mode". It appears that what
+hardware engineers mean with "GPIO mode" is not necessarily the use case
+that is implied in the kernel interface <linux/gpio.h>: a pin that you
+grab from kernel code and then either listen for input or drive high/low to
 assert/deassert some external line.
 
 Rather hardware engineers think that "GPIO mode" means that you can
-- 
1.7.11.3

