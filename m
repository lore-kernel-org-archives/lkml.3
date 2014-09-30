Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaI3Tgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:36:55 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:13418 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaI3Tgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:36:54 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Jyri Sarha <jsarha@ti.com>, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH linux-next] clk-gpio-gate: include gpio/consumer to fix build
Date: Tue, 30 Sep 2014 21:36:43 +0200
Message-Id: <1412105803-9954-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140930162635.GA7135@roeck-us.net>
References: <20140930162635.GA7135@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following build error:

  drivers/clk/clk-gpio-gate.c: In function ‘clk_gpio_gate_enable’:
  drivers/clk/clk-gpio-gate.c:36:2: error: implicit declaration of function ‘gpiod_set_value’ [-Werror=implicit-function-declaration]
  drivers/clk/clk-gpio-gate.c: In function ‘clk_gpio_gate_is_enabled’:
  drivers/clk/clk-gpio-gate.c:52:2: error: implicit declaration of function ‘gpiod_get_value’ [-Werror=implicit-function-declaration]
  drivers/clk/clk-gpio-gate.c: In function ‘clk_register_gpio_gate’:
  drivers/clk/clk-gpio-gate.c:79:2: error: implicit declaration of function ‘gpiod_is_active_low’ [-Werror=implicit-function-declaration]
  drivers/clk/clk-gpio-gate.c:85:3: error: implicit declaration of function ‘desc_to_gpio’ [-Werror=implicit-function-declaration]
  drivers/clk/clk-gpio-gate.c:125:2: error: implicit declaration of function ‘gpiod_put’ [-Werror=implicit-function-declaration]
  drivers/clk/clk-gpio-gate.c: In function ‘of_clk_gpio_gate_delayed_register_get’:
  drivers/clk/clk-gpio-gate.c:169:2: error: implicit declaration of function ‘gpio_to_desc’ [-Werror=implicit-function-declaration]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>
---

Hi,

This can be seen with e.g. linux next-20140930 and arm alldefconfig.

Best regards,

V.

 drivers/clk/clk-gpio-gate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-gpio-gate.c b/drivers/clk/clk-gpio-gate.c
index 9dde885..08e4322 100644
--- a/drivers/clk/clk-gpio-gate.c
+++ b/drivers/clk/clk-gpio-gate.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of_gpio.h>
 #include <linux/err.h>
 #include <linux/device.h>
-- 
2.1.0

