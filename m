Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174Ab3LFX1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:27:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423001Ab3LFXUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 105/152] backlight: atmel-pwm-bl: fix reported brightness
Date: Fri,  6 Dec 2013 15:10:29 -0800
Message-Id: <1386371476-2477-106-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 185d91442550110db67a7dc794a32efcea455a36 upstream.

The driver supports 16-bit brightness values, but the value returned
from get_brightness was truncated to eight bits.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index de5e5e7..f1b85ac 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -70,7 +70,7 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
 static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
 {
 	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
-	u8 intensity;
+	u32 intensity;
 
 	if (pwmbl->pdata->pwm_active_low) {
 		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
@@ -80,7 +80,7 @@ static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
 			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
 	}
 
-	return intensity;
+	return intensity & 0xffff;
 }
 
 static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
-- 
1.8.3.2

