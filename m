Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaJ2AQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:16:56 -0400
Received: from gloria.sntech.de ([95.129.55.99]:41414 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaJ2AQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:16:55 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] backlight: use of_find_backlight_by_node stub when backlight class disabled
Date: Wed, 29 Oct 2014 01:20:06 +0100
Message-ID: <50522512.UJWUZtqLop@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers may want to search for an optional backlight even when the backlight
class is disabled. In this case the linker would miss the function referenced
in the backlight header.

Therefore use the stub function also when the backlight class is disabled.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 include/linux/backlight.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index adb14a8..d9cb644 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -157,7 +157,7 @@ struct generic_bl_info {
 	void (*kick_battery)(void);
 };
 
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && defined(CONFIG_BACKLIGHT_CLASS_DEVICE)
 struct backlight_device *of_find_backlight_by_node(struct device_node *node);
 #else
 static inline struct backlight_device *
-- 
2.0.1


