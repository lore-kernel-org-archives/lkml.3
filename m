Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaGJLwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:52:06 -0400
Received: from sauhun.de ([89.238.76.85]:57078 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbaGJLqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:46:47 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/16] i2c: i2c-at91: Drop class based scanning to improve bootup time
Date: Thu, 10 Jul 2014 13:46:22 +0200
Message-Id: <1404992799-3705-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been flagged to drop class based instantiation. The removal
improves boot-up time and is unneeded for embedded controllers. Users have been
warned to switch for some time now, so we can actually do the removal. Keep the
DEPRECATED flag, so the core can inform users that the behaviour finally
changed now. After another transition period, this flag can go, too.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-at91.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index e95f9ba96790..7033e9166d1f 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -768,7 +768,7 @@ static int at91_twi_probe(struct platform_device *pdev)
 	snprintf(dev->adapter.name, sizeof(dev->adapter.name), "AT91");
 	i2c_set_adapdata(&dev->adapter, dev);
 	dev->adapter.owner = THIS_MODULE;
-	dev->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_DEPRECATED;
+	dev->adapter.class = I2C_CLASS_DEPRECATED;
 	dev->adapter.algo = &at91_twi_algorithm;
 	dev->adapter.dev.parent = dev->dev;
 	dev->adapter.nr = pdev->id;
-- 
2.0.0

