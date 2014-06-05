Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaFEEWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:22:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaFEEWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 208/214] backlight: atmel-pwm-bl: fix gpio polarity in remove
Date: Wed,  4 Jun 2014 21:19:31 -0700
Message-Id: <20140605041707.420465138@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/backlight/atmel-pwm-bl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


