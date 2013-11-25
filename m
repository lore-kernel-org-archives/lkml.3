Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab3KYIB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:01:56 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:49414 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3KYIBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:01:54 -0500
Message-ID: <529303EE.4080606@koalo.de>
Date: Mon, 25 Nov 2013 09:01:50 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH] I2C: BCM2835: Linking platform nodes to adapter nodes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to find I2C devices in the device tree, the platform nodes
have to be known by the I2C core. This requires setting the
dev.of_node parameter of the adapter.

Signed-off-by: Florian Meier <florian.meier@koalo.de>
---

Since the general approach is not easy enough
(see [PATCH] i2c: Fallback to of_node of parent),
this patch adds the required line to the bcm2835 bus.

 drivers/i2c/busses/i2c-bcm2835.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-bcm2835.c
b/drivers/i2c/busses/i2c-bcm2835.c
index ea4b08f..8beecfa 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -299,6 +299,7 @@ static int bcm2835_i2c_probe(struct platform_device
*pdev)
 	strlcpy(adap->name, "bcm2835 I2C adapter", sizeof(adap->name));
 	adap->algo = &bcm2835_i2c_algo;
 	adap->dev.parent = &pdev->dev;
+	adap->dev.of_node = pdev->dev.of_node;

 	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_C, 0);

-- 1.7.9.5
