Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaKDA4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:56:11 -0500
Received: from gloria.sntech.de ([95.129.55.99]:56825 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaKDA4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:56:07 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] backlight: extend of_find_backlight_by_node stub-check to modules
Date: Tue, 04 Nov 2014 01:59:23 +0100
Message-ID: <16457372.FsSJIFmsla@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit de3d75dc2311 ("backlight: Use of_find_backlight_by_node stub when
backlight class disabled") did not take into account that the backlight
class can also be compiled as module. Extend the check to prevent
redefinition warnings when the backlight device class is compiled as module.

Reported-by: kbuild test robot
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 include/linux/backlight.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index d9cb644..92b9817 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -157,7 +157,8 @@ struct generic_bl_info {
 	void (*kick_battery)(void);
 };
 
-#if defined(CONFIG_OF) && defined(CONFIG_BACKLIGHT_CLASS_DEVICE)
+#if defined(CONFIG_OF) && (defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || \
+			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
 struct backlight_device *of_find_backlight_by_node(struct device_node *node);
 #else
 static inline struct backlight_device *
-- 
2.0.1


