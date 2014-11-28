Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaK1JUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:20:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44621 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaK1JUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:20:25 -0500
X-AuditID: cbfee61a-f79c06d000004e71-bc-54783e578a0d
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH/RFC v8 09/14] mfd: max77693: adjust max77693_led_platform_data
Date: Fri, 28 Nov 2014 10:18:01 +0100
Message-id: <1417166286-27685-10-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd1wu4oQg+Vn9CxurTvHarFxxnpW
	i6M7JzJZfLz3j9Wi9+pzRouzTW/YLe5/PcpocXnXHDaLrW/WMVr0bNjKanH31FE2i927nrJa
	HH7TzmpxZv9KNovT3awO/B47Z91l9zj8dSGLx51re9g85p0M9Ngz/werR9+WVYwezz6+Y/ZY
	sfo7u8fnTXIBnFFcNimpOZllqUX6dglcGbeuL2MqOMNR0fNrKlMD4wT2LkZODgkBE4n7zz6z
	QdhiEhfurQeyuTiEBKYzSjx6fYIdwmlnkniz4ikrSBWbgKHEzxevmboYOThEBKIlLh2rB6lh
	FnjEJHFt2koWkBphAT+JA8c72UBqWARUJS7s0QcJ8wp4Slxr6wZrlRBQkJgzyQYkzAkUnvt5
	LQtIWEjAQ2LRq5QJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQH8TOpHYwrGywO
	MQpwMCrx8P74Vx4ixJpYVlyZe4hRgoNZSYT31FegEG9KYmVValF+fFFpTmrxIUZpDhYlcd4b
	N3NDhATSE0tSs1NTC1KLYLJMHJxSDYzl/zcF6LKv6arfyHOzNsQzcW3xz9S4JxOae+OcRFxX
	xEn6b7j18sUJI5mjml9812zUy9L7KOWdlHNLvsbH1GPi2U3NG3KnXrIT2Lvb0vbkya3d02+V
	W8+43n30wzM3CZs1c1vCIoQfvF45e9YsLvfMTcvNXx9WP5LVWnk3LUdU7VvJErvOdQeUWIoz
	Eg21mIuKEwE/HJwkXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "label" array for Device Tree strings with
the name of a LED device and make flash_timeout
a two element array, for caching the sub-led
related flash timeout.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: SangYoung Son <hello.son@smasung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/mfd/max77693.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index f0b6585..30fa19ea 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -88,14 +88,15 @@ enum max77693_led_boost_mode {
 };
 
 struct max77693_led_platform_data {
+	const char *label[2];
 	u32 fleds[2];
 	u32 iout_torch[2];
 	u32 iout_flash[2];
 	u32 trigger[2];
 	u32 trigger_type[2];
+	u32 flash_timeout[2];
 	u32 num_leds;
 	u32 boost_mode;
-	u32 flash_timeout;
 	u32 boost_vout;
 	u32 low_vsys;
 };
-- 
1.7.9.5

