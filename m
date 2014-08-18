Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaHRQjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:39:07 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5721 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHRQjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:39:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 18 Aug 2014 09:25:26 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] Documentation: gpio: documentation for optional getters functions
Date: Mon, 18 Aug 2014 09:39:01 -0700
Message-ID: <1408379941-13954-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a mention about the _optional variants of (devm_)gpiod_get*().

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/gpio/consumer.txt | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/gpio/consumer.txt b/Documentation/gpio/consumer.txt
index 76546324e968..6ce544191ca6 100644
--- a/Documentation/gpio/consumer.txt
+++ b/Documentation/gpio/consumer.txt
@@ -53,7 +53,20 @@ with IS_ERR() (they will never return a NULL pointer). -ENOENT will be returned
 if and only if no GPIO has been assigned to the device/function/index triplet,
 other error codes are used for cases where a GPIO has been assigned but an error
 occurred while trying to acquire it. This is useful to discriminate between mere
-errors and an absence of GPIO for optional GPIO parameters.
+errors and an absence of GPIO for optional GPIO parameters. For the common
+pattern where a GPIO is optional, the gpiod_get_optional() and
+gpiod_get_index_optional() functions can be used. These functions return NULL
+instead of -ENOENT if no GPIO has been assigned to the requested function:
+
+
+	struct gpio_desc *gpiod_get_optional(struct device *dev,
+					     const char *con_id,
+					     enum gpiod_flags flags)
+
+	struct gpio_desc *gpiod_get_index_optional(struct device *dev,
+						   const char *con_id,
+						   unsigned int index,
+						   enum gpiod_flags flags)
 
 Device-managed variants of these functions are also defined:
 
@@ -65,6 +78,15 @@ Device-managed variants of these functions are also defined:
 					       unsigned int idx,
 					       enum gpiod_flags flags)
 
+	struct gpio_desc *devm_gpiod_get_optional(struct device *dev,
+						  const char *con_id,
+						  enum gpiod_flags flags)
+
+	struct gpio_desc * devm_gpiod_get_index_optional(struct device *dev,
+							const char *con_id,
+							unsigned int index,
+							enum gpiod_flags flags)
+
 A GPIO descriptor can be disposed of using the gpiod_put() function:
 
 	void gpiod_put(struct gpio_desc *desc)
-- 
2.0.4

