Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaDYQW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:22:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:6991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbaDYQWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:22:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="519800467"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 3/3] Input: gpio_keys - convert struct descriptions to kernel-doc
Date: Fri, 25 Apr 2014 19:22:17 +0300
Message-Id: <1398442937-15309-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398442937-15309-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1398442937-15309-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts descriptions of the structures defined in linux/gpio_keys.h
to follow kernel-doc format.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/gpio_keys.h | 45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/linux/gpio_keys.h b/include/linux/gpio_keys.h
index a7e977f..997134a 100644
--- a/include/linux/gpio_keys.h
+++ b/include/linux/gpio_keys.h
@@ -3,29 +3,50 @@
 
 struct device;
 
+/**
+ * struct gpio_keys_button - configuration parameters
+ * @code:		input event code (KEY_*, SW_*)
+ * @gpio:		%-1 if this key does not support gpio
+ * @active_low:
+ * @desc:
+ * @type:		input event type (%EV_KEY, %EV_SW, %EV_ABS)
+ * @wakeup:		configure the button as a wake-up source
+ * @debounce_interval:	debounce ticks interval in msecs
+ * @can_disable:
+ * @value:		axis value for %EV_ABS
+ * @irq:		Irq number in case of interrupt keys
+ */
 struct gpio_keys_button {
-	/* Configuration parameters */
-	unsigned int code;	/* input event code (KEY_*, SW_*) */
-	int gpio;		/* -1 if this key does not support gpio */
+	unsigned int code;
+	int gpio;
 	int active_low;
 	const char *desc;
-	unsigned int type;	/* input event type (EV_KEY, EV_SW, EV_ABS) */
-	int wakeup;		/* configure the button as a wake-up source */
-	int debounce_interval;	/* debounce ticks interval in msecs */
+	unsigned int type;
+	int wakeup;
+	int debounce_interval;
 	bool can_disable;
-	int value;		/* axis value for EV_ABS */
-	unsigned int irq;	/* Irq number in case of interrupt keys */
+	int value;
+	unsigned int irq;
 };
 
+/**
+ * struct gpio_keys_platform_data - platform data for gpio_keys driver
+ * @buttons:
+ * @nbuttons:
+ * @poll_interval:	polling interval in msecs - for polling driver only
+ * @rep:		enable input subsystem auto repeat
+ * @enable:
+ * @disable:
+ * @name:		input device name
+ */
 struct gpio_keys_platform_data {
 	struct gpio_keys_button *buttons;
 	int nbuttons;
-	unsigned int poll_interval;	/* polling interval in msecs -
-					   for polling driver only */
-	unsigned int rep:1;		/* enable input subsystem auto repeat */
+	unsigned int poll_interval;
+	unsigned int rep:1;
 	int (*enable)(struct device *dev);
 	void (*disable)(struct device *dev);
-	const char *name;		/* input device name */
+	const char *name;
 };
 
 #endif
-- 
1.9.2

