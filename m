Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab3KHJtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:49:31 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:36009 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3KHJtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:49:25 -0500
Message-ID: <527CB3A1.7050808@koalo.de>
Date: Fri, 08 Nov 2013 10:49:21 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] I2C: BCM2835: Linking platform nodes to adapter nodes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to find I2C devices in the device tree, the platform nodes
have to be known by the I2C core. Analogous to the i2c-omap driver
this requires setting the dev.of_node parameter of the adapter.

Signed-off-by: Florian Meier <florian.meier@koalo.de>
---

I don't know if this is really necessary, but for me it does not work
without this line.

 drivers/i2c/busses/i2c-bcm2835.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
index ea4b08f..8beecfa 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -299,6 +299,7 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
 	strlcpy(adap->name, "bcm2835 I2C adapter", sizeof(adap->name));
 	adap->algo = &bcm2835_i2c_algo;
 	adap->dev.parent = &pdev->dev;
+	adap->dev.of_node = pdev->dev.of_node;
 
 	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_C, 0);
 
-- 
1.7.9.5
