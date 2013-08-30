Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab3H3Ebf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:31:35 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41021 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab3H3E3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:29:54 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/6] extcon-gpio: If the gpio driver/chip supports debounce, use it
Date: Thu, 29 Aug 2013 21:29:34 -0700
Message-Id: <1377836978-24082-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/extcon/extcon-gpio.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 77d35a7..973600e 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -111,6 +111,11 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err;
 
+	/* Use gpio debounce if available. If so, don't debounce in software. */
+	if (pdata->debounce &&
+	    !gpio_set_debounce(extcon_data->gpio, pdata->debounce * 1000))
+		extcon_data->debounce_jiffies = 0;
+
 	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
 
 	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
-- 
1.7.9.7

