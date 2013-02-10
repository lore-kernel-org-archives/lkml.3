Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3BJN6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 08:58:06 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:35693 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab3BJN6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 08:58:05 -0500
From: Alexandre Courbot <gnurou@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpiolib: fix link error when sysfs is not built
Date: Sun, 10 Feb 2013 23:00:21 +0900
Message-Id: <1360504821-13110-1-git-send-email-gnurou@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <CACxGe6tAEX7o9dxNTXtwKwzZHmEteKAS+7uy4j-DTX_2V583tg@mail.gmail.com>
References: <CACxGe6tAEX7o9dxNTXtwKwzZHmEteKAS+7uy4j-DTX_2V583tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Courbot <acourbot@nvidia.com>

Fix all compilation errors and warnings triggered by my latest series of
patch on Grant's linux-next branch. Please meld this patch into the culprit
one to avoid ending with a commit that breaks compilation in the git history.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index b24e820..d283e70 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1087,6 +1087,27 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
 {
 }
 
+static inline int gpiod_export(struct gpio_desc *desc,
+			       bool direction_may_change)
+{
+	return -ENOSYS;
+}
+
+static inline int gpiod_export_link(struct device *dev, const char *name,
+				    struct gpio_desc *desc)
+{
+	return -ENOSYS;
+}
+
+static inline int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
+{
+	return -ENOSYS;
+}
+
+static inline void gpiod_unexport(struct gpio_desc *desc)
+{
+}
+
 #endif /* CONFIG_GPIO_SYSFS */
 
 /*
-- 
1.8.1.3

