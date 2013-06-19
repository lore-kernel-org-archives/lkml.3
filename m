Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935083Ab3FSS1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:27:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37441 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935067Ab3FSS1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:27:09 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [RFC 2/2] i2c: gpio: drop class based instantiation of slaves
Date: Wed, 19 Jun 2013 21:22:12 +0300
Message-ID: <1371666132-29655-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371666132-29655-1-git-send-email-grygorii.strashko@ti.com>
References: <1370596166-12404-1-git-send-email-wsa@the-dreams.de>
 <1371666132-29655-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Class based instantiation mechanism can cause huge delays when booting.
For example: when CONFIG_SENSORS_LM75 option is enabled for or omap5-uevm board,
where i2c-gpio is used for HDMI edid reading - it introduces up to 5 sec boot
delay.
It's not recommended to use this mechanism with embedded I2C, so disable it by
leaving I2C adapter "class" field undefined (remove I2C_CLASS_HWMON and
I2C_CLASS_SPD) and add a deprecation warning to allow users, relying on this
mechanism, to switch to something better.

CC: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/i2c/busses/i2c-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index bc6e139..33e3d0e 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -215,7 +215,7 @@ static int i2c_gpio_probe(struct platform_device *pdev)
 		snprintf(adap->name, sizeof(adap->name), "i2c-gpio%d", pdev->id);
 
 	adap->algo_data = bit_data;
-	adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
+	adap->class = I2C_CLASS_DEPRECATED;
 	adap->dev.parent = &pdev->dev;
 	adap->dev.of_node = pdev->dev.of_node;
 
-- 
1.7.9.5

