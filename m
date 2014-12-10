Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbaLJPZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:25:36 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:52817 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbaLJPZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:25:09 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3 4/4] gpio/xilinx: Fix kernel-doc
Date: Wed, 10 Dec 2014 16:25:00 +0100
Message-Id: <1418225100-2949-5-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418225100-2949-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1418225100-2949-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some documentation were not following the kernel-doc format.
Backporting patch from Xilinx git repository.

Suggested-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

v4: New patch

 drivers/gpio/gpio-xilinx.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 0607d97..0297003 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -40,11 +40,11 @@
 
 /**
  * struct xgpio_instance - Stores information about GPIO device
- * struct of_mm_gpio_chip mmchip: OF GPIO chip for memory mapped banks
- * gpio_state: GPIO state shadow register
- * gpio_dir: GPIO direction shadow register
- * gpio_lock: Lock used for synchronization
- * inited: True if the port has been inited
+ * @mmchip: OF GPIO chip for memory mapped banks
+ * @gpio_state: GPIO state shadow register
+ * @gpio_dir: GPIO direction shadow register
+ * @gpio_lock: Lock used for synchronization
+ * @inited: True if the port has been inited
  */
 struct xgpio_instance {
 	struct of_mm_gpio_chip mmchip;
@@ -63,8 +63,11 @@ struct xgpio {
  * @gc:     Pointer to gpio_chip device structure.
  * @gpio:   GPIO signal number.
  *
- * This function reads the specified signal of the GPIO device. It returns 0 if
- * the signal clear, 1 if signal is set or negative value on error.
+ * This function reads the specified signal of the GPIO device.
+ *
+ * Return:
+ * 0 if direction of GPIO signals is set as input otherwise it
+ * returns negative error value.
  */
 static int xgpio_get(struct gpio_chip *gc, unsigned int gpio)
 {
@@ -107,9 +110,9 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
  * @gc:     Pointer to gpio_chip device structure.
  * @gpio:   GPIO signal number.
  *
- * This function sets the direction of specified GPIO signal as input.
- * It returns 0 if direction of GPIO signals is set as input otherwise it
- * returns negative error value.
+ * Return:
+ * 0 - if direction of GPIO signals is set as input
+ * otherwise it returns negative error value.
  */
 static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 {
@@ -135,8 +138,10 @@ static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
  * @gpio:   GPIO signal number.
  * @val:    Value to be written to specified signal.
  *
- * This function sets the direction of specified GPIO signal as output. If all
- * GPIO signals of GPIO chip is configured as input then it returns
+ * This function sets the direction of specified GPIO signal as output.
+ *
+ * Return:
+ * If all GPIO signals of GPIO chip is configured as input then it returns
  * error otherwise it returns 0.
  */
 static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
@@ -166,7 +171,7 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 
 /**
  * xgpio_save_regs - Set initial values of GPIO pins
- * @mm_gc: pointer to memory mapped GPIO chip structure
+ * @mm_gc: Pointer to memory mapped GPIO chip structure
  */
 static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 {
@@ -207,9 +212,9 @@ static int xgpio_remove(struct platform_device *pdev)
  * xgpio_of_probe - Probe method for the GPIO device.
  * @pdev: pointer to the platform device
  *
- * This function probes the GPIO device in the device tree. It initializes the
- * driver data structure. It returns 0, if the driver is bound to the GPIO
- * device, or a negative value if there is an error.
+ * Return:
+ * It returns 0, if the driver is bound to the GPIO device, or
+ * a negative value if there is an error.
  */
 static int xgpio_probe(struct platform_device *pdev)
 {
-- 
2.1.3

