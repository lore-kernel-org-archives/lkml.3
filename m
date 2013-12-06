Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422980Ab3LFXU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:20:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48934 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3LFXUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 106/152] backlight: atmel-pwm-bl: fix gpio polarity in remove
Date: Fri,  6 Dec 2013 15:10:30 -0800
Message-Id: <1386371476-2477-107-git-send-email-kamal@canonical.com>
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

commit ad5066d4c2b1d696749f8d7816357c23b648c4d3 upstream.

Make sure to honour gpio polarity also at remove so that the backlight is
actually disabled on boards with active-low enable pin.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index f1b85ac..96d07a1 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -207,8 +207,10 @@ static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
 {
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
-	if (pwmbl->gpio_on != -1)
-		gpio_set_value(pwmbl->gpio_on, 0);
+	if (pwmbl->gpio_on != -1) {
+		gpio_set_value(pwmbl->gpio_on,
+					0 ^ pwmbl->pdata->on_active_low);
+	}
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
 	backlight_device_unregister(pwmbl->bldev);
-- 
1.8.3.2

