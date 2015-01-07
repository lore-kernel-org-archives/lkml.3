Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbbAGIpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:45:08 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:42762 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbbAGIpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:45:07 -0500
From: Olliver Schinagl <oliver+list@schinagl.nl>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Olliver Schinagl <oliver@schinagl.nl>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] gpio: Make the vararg hacks not pass magic values
Date: Wed,  7 Jan 2015 09:44:57 +0100
Message-Id: <1420620297-7329-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <oliver@schinagl.nl>

Right now, in consumer.h, there's some vararg hacks that pass 0 as the
flags. What actually is passed however is GPIOD_ASIS, which naturally is
also 0. Using the define/enum rather then the magic 0 makes it the
define more readable to a passer by.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 include/linux/gpio/consumer.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index fd85cb1..45afc2d 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -340,31 +340,32 @@ static inline int desc_to_gpio(const struct gpio_desc *desc)
  * etc.
  */
 #define __gpiod_get(dev, con_id, flags, ...) __gpiod_get(dev, con_id, flags)
-#define gpiod_get(varargs...) __gpiod_get(varargs, 0)
+#define gpiod_get(varargs...) __gpiod_get(varargs, GPIOD_ASIS)
 #define __gpiod_get_index(dev, con_id, index, flags, ...)		\
 	__gpiod_get_index(dev, con_id, index, flags)
-#define gpiod_get_index(varargs...) __gpiod_get_index(varargs, 0)
+#define gpiod_get_index(varargs...) __gpiod_get_index(varargs, GPIOD_ASIS)
 #define __gpiod_get_optional(dev, con_id, flags, ...)			\
 	__gpiod_get_optional(dev, con_id, flags)
-#define gpiod_get_optional(varargs...) __gpiod_get_optional(varargs, 0)
+#define gpiod_get_optional(varargs...) __gpiod_get_optional(varargs, GPIOD_ASIS)
 #define __gpiod_get_index_optional(dev, con_id, index, flags, ...)	\
 	__gpiod_get_index_optional(dev, con_id, index, flags)
 #define gpiod_get_index_optional(varargs...)				\
-	__gpiod_get_index_optional(varargs, 0)
+	__gpiod_get_index_optional(varargs, GPIOD_ASIS)
 #define __devm_gpiod_get(dev, con_id, flags, ...)			\
 	__devm_gpiod_get(dev, con_id, flags)
-#define devm_gpiod_get(varargs...) __devm_gpiod_get(varargs, 0)
+#define devm_gpiod_get(varargs...) __devm_gpiod_get(varargs, GPIOD_ASIS)
 #define __devm_gpiod_get_index(dev, con_id, index, flags, ...)		\
 	__devm_gpiod_get_index(dev, con_id, index, flags)
-#define devm_gpiod_get_index(varargs...) __devm_gpiod_get_index(varargs, 0)
+#define devm_gpiod_get_index(varargs...)				\
+	__devm_gpiod_get_index(varargs, GPIOD_ASIS)
 #define __devm_gpiod_get_optional(dev, con_id, flags, ...)		\
 	__devm_gpiod_get_optional(dev, con_id, flags)
 #define devm_gpiod_get_optional(varargs...)				\
-	__devm_gpiod_get_optional(varargs, 0)
+	__devm_gpiod_get_optional(varargs, GPIOD_ASIS)
 #define __devm_gpiod_get_index_optional(dev, con_id, index, flags, ...)	\
 	__devm_gpiod_get_index_optional(dev, con_id, index, flags)
 #define devm_gpiod_get_index_optional(varargs...)			\
-	__devm_gpiod_get_index_optional(varargs, 0)
+	__devm_gpiod_get_index_optional(varargs, GPIOD_ASIS)
 
 #if IS_ENABLED(CONFIG_GPIOLIB) && IS_ENABLED(CONFIG_GPIO_SYSFS)
 
-- 
2.1.4

