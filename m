Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaGIJE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:04:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37963 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbaGIJEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:04:52 -0400
From: George Cherian <george.cherian@ti.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>,
        <grant.likely@linaro.org>, <rdunlap@infradead.org>,
        <galak@codeaurora.org>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <george.cherian@ti.com>
Subject: [PATCH v2 1/2] extcon: gpio: Minor cleanups
Date: Wed, 9 Jul 2014 14:31:07 +0530
Message-ID: <1404896468-15974-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1404896468-15974-1-git-send-email-george.cherian@ti.com>
References: <1404896468-15974-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor Cleanups
 - Order the include files in alphabetical order.
 - Fix description of state_off in extcon_gpio.h
 - Add a descrition for check_on_resume in extcon_gpio.h

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/extcon/extcon-gpio.c       | 10 +++++-----
 include/linux/extcon/extcon-gpio.h |  4 +++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 645b283..6c268b4 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -20,16 +20,16 @@
  *
 */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
+#include <linux/extcon.h>
+#include <linux/extcon/extcon-gpio.h>
+#include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
-#include <linux/gpio.h>
-#include <linux/extcon.h>
-#include <linux/extcon/extcon-gpio.h>
 
 struct gpio_extcon_data {
 	struct extcon_dev *edev;
diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
index 8900fdf..0b17ad4 100644
--- a/include/linux/extcon/extcon-gpio.h
+++ b/include/linux/extcon/extcon-gpio.h
@@ -34,8 +34,10 @@
  * @irq_flags:		IRQ Flags (e.g., IRQF_TRIGGER_LOW).
  * @state_on:		print_state is overriden with state_on if attached.
  *			If NULL, default method of extcon class is used.
- * @state_off:		print_state is overriden with state_on if detached.
+ * @state_off:		print_state is overriden with state_off if detached.
  *			If NUll, default method of extcon class is used.
+ * @check_on_resume:	Boolean describing whether to check the state of gpio
+ *			while resuming from sleep.
  *
  * Note that in order for state_on or state_off to be valid, both state_on
  * and state_off should be not NULL. If at least one of them is NULL,
-- 
1.8.3.1

