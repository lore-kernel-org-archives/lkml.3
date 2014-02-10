Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaBJKK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:10:26 -0500
Received: from sauhun.de ([89.238.76.85]:38537 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbaBJKE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:29 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/17] i2c: i2c-at91: deprecate class based instantiation
Date: Mon, 10 Feb 2014 11:03:58 +0100
Message-Id: <1392026654-5343-5-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn users that class based instantiation is going away soon in favour
of more robust probing and faster bootup times.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
---

 drivers/i2c/busses/i2c-at91.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 8edba9d..4babcdb 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -759,7 +759,7 @@ static int at91_twi_probe(struct platform_device *pdev)
 	snprintf(dev->adapter.name, sizeof(dev->adapter.name), "AT91");
 	i2c_set_adapdata(&dev->adapter, dev);
 	dev->adapter.owner = THIS_MODULE;
-	dev->adapter.class = I2C_CLASS_HWMON;
+	dev->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_DEPRECATED;
 	dev->adapter.algo = &at91_twi_algorithm;
 	dev->adapter.dev.parent = dev->dev;
 	dev->adapter.nr = pdev->id;
-- 
1.8.5.1

