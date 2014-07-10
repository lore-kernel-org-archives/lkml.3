Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaGJLuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:50:46 -0400
Received: from sauhun.de ([89.238.76.85]:57081 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbaGJLqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:46:48 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] i2c: i2c-bcm2835: Drop class based scanning to improve bootup time
Date: Thu, 10 Jul 2014 13:46:23 +0200
Message-Id: <1404992799-3705-4-git-send-email-wsa@the-dreams.de>
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
 drivers/i2c/busses/i2c-bcm2835.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
index 214ff9700efe..4b8ecd0b3661 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -277,7 +277,7 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
 	adap = &i2c_dev->adapter;
 	i2c_set_adapdata(adap, i2c_dev);
 	adap->owner = THIS_MODULE;
-	adap->class = I2C_CLASS_HWMON | I2C_CLASS_DEPRECATED;
+	adap->class = I2C_CLASS_DEPRECATED;
 	strlcpy(adap->name, "bcm2835 I2C adapter", sizeof(adap->name));
 	adap->algo = &bcm2835_i2c_algo;
 	adap->dev.parent = &pdev->dev;
-- 
2.0.0

