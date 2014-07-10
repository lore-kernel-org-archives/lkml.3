Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaGJLrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:47:06 -0400
Received: from sauhun.de ([89.238.76.85]:57111 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaGJLrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:47:03 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] i2c: i2c-s3c2410: Drop class based scanning to improve bootup time
Date: Thu, 10 Jul 2014 13:46:32 +0200
Message-Id: <1404992799-3705-13-git-send-email-wsa@the-dreams.de>
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
While we are here, remove the indentation for the array setup because
such things always break after some time.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-s3c2410.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index e828a1dba0e5..6252c051525a 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1128,11 +1128,11 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		s3c24xx_i2c_parse_dt(pdev->dev.of_node, i2c);
 
 	strlcpy(i2c->adap.name, "s3c2410-i2c", sizeof(i2c->adap.name));
-	i2c->adap.owner   = THIS_MODULE;
-	i2c->adap.algo    = &s3c24xx_i2c_algorithm;
+	i2c->adap.owner = THIS_MODULE;
+	i2c->adap.algo = &s3c24xx_i2c_algorithm;
 	i2c->adap.retries = 2;
-	i2c->adap.class   = I2C_CLASS_HWMON | I2C_CLASS_SPD | I2C_CLASS_DEPRECATED;
-	i2c->tx_setup     = 50;
+	i2c->adap.class = I2C_CLASS_DEPRECATED;
+	i2c->tx_setup = 50;
 
 	init_waitqueue_head(&i2c->wait);
 
-- 
2.0.0

