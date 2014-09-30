Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaI3Ob1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:31:27 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:49551 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbaI3ObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:31:22 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH 1/2] input: remove use of gpiochip_remove() retval
Date: Tue, 30 Sep 2014 20:04:53 +0530
Message-Id: <1412087693-8277-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of using return value from gpiochip_remove() as it returns
void.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: linux-gpio@vger.kernel.org

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/keyboard/adp5588-keys.c |    4 +---
 drivers/input/keyboard/adp5589-keys.c |    4 +---
 drivers/input/touchscreen/ad7879.c    |    9 ++-------
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index 5ef7fcf..b97ed44 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -251,9 +251,7 @@ static void adp5588_gpio_remove(struct adp5588_kpad *kpad)
 			dev_warn(dev, "teardown failed %d\n", error);
 	}
 
-	error = gpiochip_remove(&kpad->gc);
-	if (error)
-		dev_warn(dev, "gpiochip_remove failed %d\n", error);
+	gpiochip_remove(&kpad->gc);
 }
 #else
 static inline int adp5588_gpio_add(struct adp5588_kpad *kpad)
diff --git a/drivers/input/keyboard/adp5589-keys.c b/drivers/input/keyboard/adp5589-keys.c
index 6329549..a452677 100644
--- a/drivers/input/keyboard/adp5589-keys.c
+++ b/drivers/input/keyboard/adp5589-keys.c
@@ -567,9 +567,7 @@ static void adp5589_gpio_remove(struct adp5589_kpad *kpad)
 			dev_warn(dev, "teardown failed %d\n", error);
 	}
 
-	error = gpiochip_remove(&kpad->gc);
-	if (error)
-		dev_warn(dev, "gpiochip_remove failed %d\n", error);
+	gpiochip_remove(&kpad->gc);
 }
 #else
 static inline int adp5589_gpio_add(struct adp5589_kpad *kpad)
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index fce5906..ee3bb4d 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -470,14 +470,9 @@ static int ad7879_gpio_add(struct ad7879 *ts,
 static void ad7879_gpio_remove(struct ad7879 *ts)
 {
 	const struct ad7879_platform_data *pdata = dev_get_platdata(ts->dev);
-	int ret;
 
-	if (pdata->gpio_export) {
-		ret = gpiochip_remove(&ts->gc);
-		if (ret)
-			dev_err(ts->dev, "failed to remove gpio %d\n",
-				ts->gc.base);
-	}
+	if (pdata->gpio_export)
+		gpiochip_remove(&ts->gc);
 }
 #else
 static inline int ad7879_gpio_add(struct ad7879 *ts,
-- 
1.7.9.5

