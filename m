Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaKCQdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:33:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57965 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaKCQdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:33:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>, George Cherian <george.cherian@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3/4] extcon: gpio: Always use gpio_get_value_cansleep
Date: Mon, 3 Nov 2014 10:32:29 -0600
Message-ID: <1415032350-8459-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
In-Reply-To: <1415032350-8459-1-git-send-email-balbi@ti.com>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Cherian <george.cherian@ti.com>

Some gpio's can sleep while reading, so always use gpio_get_value_cansleep
to get data. This fixes warning from gpiolib due to wrong API usage.

Reviewed-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/extcon/extcon-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 9571e1f..7191d28 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -51,7 +51,7 @@ static void gpio_extcon_work(struct work_struct *work)
 		container_of(to_delayed_work(work), struct gpio_extcon_data,
 			     work);
 
-	state = gpiod_get_value(data->gpiod);
+	state = gpiod_get_value_cansleep(data->gpiod);
 	extcon_set_state(data->edev, state);
 }
 
-- 
2.1.0.GIT

