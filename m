Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbaIIER2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:17:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50113 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbaIIER0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:17:26 -0400
From: George Cherian <george.cherian@ti.com>
To: <cw00.choi@samsung.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <myungjoo.ham@samsung.com>,
        <grant.likely@linaro.org>, <rongjun.ying@csr.com>,
        <linux@roeck-us.net>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 4/5] extcon: gpio: Always use gpio_get_value_cansleep
Date: Tue, 9 Sep 2014 09:44:37 +0530
Message-ID: <1410236078-11713-5-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
References: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some gpio's can sleep while reading, so always use gpio_get_value_cansleep
to get data. This fixes warning from gpiolib due to wrong API usage.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/extcon/extcon-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 2bfbd2e..3839749 100644
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
1.8.3.1

