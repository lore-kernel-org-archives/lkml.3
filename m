Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaGKOEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:04:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59385 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaGKOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:49 -0400
X-AuditID: cbfee61a-f79e46d00000134f-7e-53bfeeff60be
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 05/21] leds: avoid using deprecated DEVICE_ATTR macro
Date: Fri, 11 Jul 2014 16:04:08 +0200
Message-id: <1405087464-13762-6-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd3/7/YHG5z8aGKxccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktdu96yurA6bFz1l12jz3zf7B69G1Z
	xejxeZNcAEsUl01Kak5mWWqRvl0CV8b8Jd/ZC45wVnx5tZK1gXEaRxcjJ4eEgInEg0Vv2CFs
	MYkL99azdTFycQgJTGeUeNh1C8ppZ5JY9/clI0gVm4ChxM8Xr5lAbBGBcome98/AipgFVjNK
	3Nn6lRUkISzgI9Fy5wwbiM0ioCrxp+ki2ApeAQ+JJ2tuMHcxcgCtU5CYM8kGJMwp4ClxsP8m
	WLkQUMnDtSfYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHGDPpHYwrmywOMQo
	wMGoxMOrsH5fsBBrYllxZe4hRgkOZiUR3qtv9gcL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Q
	ah0oJJCeWJKanZpakFoEk2Xi4JRqYHQw2PMtvkGW9+jS0/Pfm3ysvejFcCZtcXCZ2opvTuJ/
	7+/KE7JXb3AVm8v59j2zaOSaTWsTtR3kDzG97PV5/LqqdHngcu+5XKIpJarvJvo1ujmes8ia
	e2jVd5XAs3cjVOdM6dlYvMSo6uLmF7uW6/v6f/y80kFxXWq6Voy61zvpjT0xfV+l9JVYijMS
	DbWYi4oTAbBS1tksAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the sysfs attributes definition consistent in the whole file.
The modification entails change of the function name:
led_max_brightness_show -> max_brightness_show

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 0127783..a96a1a7 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -60,14 +60,14 @@ unlock:
 }
 static DEVICE_ATTR_RW(brightness);
 
-static ssize_t led_max_brightness_show(struct device *dev,
+static ssize_t max_brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%u\n", led_cdev->max_brightness);
 }
-static DEVICE_ATTR(max_brightness, 0444, led_max_brightness_show, NULL);
+static DEVICE_ATTR_RO(max_brightness);
 
 #ifdef CONFIG_LEDS_TRIGGERS
 static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
-- 
1.7.9.5

