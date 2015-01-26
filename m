Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbbAZLEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:04:40 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:40585 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbbAZLEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:04:22 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/2] gpio: sysfs: fix memory leak in gpiod_sysfs_set_active_low
Date: Mon, 26 Jan 2015 12:02:46 +0100
Message-Id: <1422270166-17525-3-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422270166-17525-1-git-send-email-johan@kernel.org>
References: <1422270166-17525-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory leak in the gpio sysfs interface due to failure to drop
reference to device returned by class_find_device when setting the
gpio-line polarity.

Fixes: 0769746183ca ("gpiolib: add support for changing value polarity
in sysfs")
Cc: stable <stable@vger.kernel.org>	# v2.6.33
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 820b1e70ddfe..4908d09873e5 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -696,7 +696,7 @@ int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
 	}
 
 	status = sysfs_set_active_low(desc, dev, value);
-
+	put_device(dev);
 unlock:
 	mutex_unlock(&sysfs_lock);
 
-- 
2.0.5

