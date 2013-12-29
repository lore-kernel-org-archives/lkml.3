Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3L2CK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55506 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142Ab3L2CKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jingoo Han" <jg1.han@samsung.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.567396762@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 059/185] backlight: atmel-pwm-bl: fix gpio polarity in
 remove
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ad5066d4c2b1d696749f8d7816357c23b648c4d3 upstream.

Make sure to honour gpio polarity also at remove so that the backlight is
actually disabled on boards with active-low enable pin.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/backlight/atmel-pwm-bl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -211,7 +211,8 @@ static int __exit atmel_pwm_bl_remove(st
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
 	if (pwmbl->gpio_on != -1) {
-		gpio_set_value(pwmbl->gpio_on, 0);
+		gpio_set_value(pwmbl->gpio_on,
+					0 ^ pwmbl->pdata->on_active_low);
 		gpio_free(pwmbl->gpio_on);
 	}
 	pwm_channel_disable(&pwmbl->pwmc);

