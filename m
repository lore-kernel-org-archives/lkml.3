Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab3BBQ37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:29:59 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:42009 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab3BBQ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:27:29 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/9] gpiolib: use gpio_chips list in gpiolib_sysfs_init
Date: Sun,  3 Feb 2013 01:29:25 +0900
Message-Id: <1359822572-26009-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the small list of GPIO chips instead of parsing the whole GPIO
number space.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 0050766..4ceb4a7 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -973,7 +973,7 @@ static int __init gpiolib_sysfs_init(void)
 {
 	int		status;
 	unsigned long	flags;
-	unsigned	gpio;
+	struct gpio_chip *chip;
 
 	status = class_register(&gpio_class);
 	if (status < 0)
@@ -986,10 +986,7 @@ static int __init gpiolib_sysfs_init(void)
 	 * registered, and so arch_initcall() can always gpio_export().
 	 */
 	spin_lock_irqsave(&gpio_lock, flags);
-	for (gpio = 0; gpio < ARCH_NR_GPIOS; gpio++) {
-		struct gpio_chip	*chip;
-
-		chip = gpio_desc[gpio].chip;
+	list_for_each_entry(chip, &gpio_chips, list) {
 		if (!chip || chip->exported)
 			continue;
 
-- 
1.8.1.1

