Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3COATn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:19:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45181 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab3COATl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:19:41 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: lp55xx: fix the sysfs read operation
Thread-Topic: [PATCH] leds: lp55xx: fix the sysfs read operation
Thread-Index: Ac4hEsYkoy0x+pvmT/G8elFtCbnXnw==
Date: Fri, 15 Mar 2013 00:19:36 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E48A16@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to a sysfs documentation(Documentation/filesystem/sysfs.txt),
scnprintf() should be used in a read operation method.
It guarantees safe buffer size(PAGE_SIZE) which is allocated by the sysfs.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |    3 ++-
 drivers/leds/leds-lp55xx-common.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 1001347..7f10304 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -360,7 +360,8 @@ static ssize_t lp5521_selftest(struct device *dev,
 	mutex_lock(&chip->lock);
 	ret = lp5521_run_selftest(chip, buf);
 	mutex_unlock(&chip->lock);
-	return sprintf(buf, "%s\n", ret ? "FAIL" : "OK");
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", ret ? "FAIL" : "OK");
 }
 
 /* device attributes */
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 8a388a4..715a602 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -80,7 +80,7 @@ static ssize_t lp55xx_show_current(struct device *dev,
 {
 	struct lp55xx_led *led = dev_to_lp55xx_led(dev);
 
-	return sprintf(buf, "%d\n", led->led_current);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", led->led_current);
 }
 
 static ssize_t lp55xx_store_current(struct device *dev,
@@ -113,7 +113,7 @@ static ssize_t lp55xx_show_max_current(struct device *dev,
 {
 	struct lp55xx_led *led = dev_to_lp55xx_led(dev);
 
-	return sprintf(buf, "%d\n", led->max_current);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", led->max_current);
 }
 
 static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, lp55xx_show_current,
-- 
1.7.9.5


Best Regards,
Milo


