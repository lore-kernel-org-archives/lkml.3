Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3KYNOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:14:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57308 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab3KYNJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:09:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 67/78] backlight: atmel-pwm-bl: fix gpio polarity in remove
Date: Mon, 25 Nov 2013 13:06:54 +0000
Message-Id: <1385384825-21681-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ad5066d4c2b1d696749f8d7816357c23b648c4d3 upstream.

Make sure to honour gpio polarity also at remove so that the backlight is
actually disabled on boards with active-low enable pin.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 4d2bbd8..dab3a0c 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -211,7 +211,8 @@ static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
 	if (pwmbl->gpio_on != -1) {
-		gpio_set_value(pwmbl->gpio_on, 0);
+		gpio_set_value(pwmbl->gpio_on,
+					0 ^ pwmbl->pdata->on_active_low);
 		gpio_free(pwmbl->gpio_on);
 	}
 	pwm_channel_disable(&pwmbl->pwmc);
-- 
1.8.3.2

