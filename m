Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaEVCTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 22:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaEVCTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 22:19:47 -0400
From: Flavio Leitner <fbl@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Flavio Leitner <fbl@sysclose.org>
Subject: [PATCH] i8k: increase fan limit to 3
Date: Wed, 21 May 2014 23:19:28 -0300
Message-Id: <1400725168-21358-1-git-send-email-fbl@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Flavio Leitner <fbl@sysclose.org>

It is possible to increase left fan speed on a
DELL Precision 490n system up to 3.

    value    fan rpm
      1      35460
      2      64740
      3      78510

Signed-off-by: Flavio Leitner <fbl@sysclose.org>
---
 drivers/char/i8k.c       | 4 ++--
 include/uapi/linux/i8k.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index d915707..99180f0 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -519,7 +519,7 @@ static ssize_t i8k_hwmon_show_pwm(struct device *dev,
 	status = i8k_get_fan_status(index);
 	if (status < 0)
 		return -EIO;
-	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 255));
+	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 384));
 }
 
 static ssize_t i8k_hwmon_set_pwm(struct device *dev,
@@ -533,7 +533,7 @@ static ssize_t i8k_hwmon_set_pwm(struct device *dev,
 	err = kstrtoul(buf, 10, &val);
 	if (err)
 		return err;
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 128), 0, 2);
+	val = clamp_val(DIV_ROUND_CLOSEST(val, 128), 0, 3);
 
 	mutex_lock(&i8k_mutex);
 	err = i8k_set_fan(index, val);
diff --git a/include/uapi/linux/i8k.h b/include/uapi/linux/i8k.h
index 1c45ba5..133d02f 100644
--- a/include/uapi/linux/i8k.h
+++ b/include/uapi/linux/i8k.h
@@ -34,7 +34,8 @@
 #define I8K_FAN_OFF		0
 #define I8K_FAN_LOW		1
 #define I8K_FAN_HIGH		2
-#define I8K_FAN_MAX		I8K_FAN_HIGH
+#define I8K_FAN_TURBO		3
+#define I8K_FAN_MAX		I8K_FAN_TURBO
 
 #define I8K_VOL_UP		1
 #define I8K_VOL_DOWN		2
-- 
1.9.0

