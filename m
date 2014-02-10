Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaBJKEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:04:47 -0500
Received: from sauhun.de ([89.238.76.85]:38562 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaBJKEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:43 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/17] i2c: i2c-s3c2410: deprecate class based instantiation
Date: Mon, 10 Feb 2014 11:04:07 +0100
Message-Id: <1392026654-5343-14-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn users that class based instantiation is going away soon in favour
of more robust probing and faster bootup times.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---

This patch is a suggestion. Looking for an ack by someone who actually uses
the driver.

 drivers/i2c/busses/i2c-s3c2410.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index bf8fb94..4a623e0 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1062,7 +1062,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	i2c->adap.owner   = THIS_MODULE;
 	i2c->adap.algo    = &s3c24xx_i2c_algorithm;
 	i2c->adap.retries = 2;
-	i2c->adap.class   = I2C_CLASS_HWMON | I2C_CLASS_SPD;
+	i2c->adap.class   = I2C_CLASS_HWMON | I2C_CLASS_SPD | I2C_CLASS_DEPRECATED;
 	i2c->tx_setup     = 50;
 
 	init_waitqueue_head(&i2c->wait);
-- 
1.8.5.1

