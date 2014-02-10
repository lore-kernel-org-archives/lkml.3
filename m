Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaBJKJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:09:23 -0500
Received: from sauhun.de ([89.238.76.85]:38545 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaBJKEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:32 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Sonic Zhang <sonic.zhang@analog.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/17] i2c: i2c-bfin-twi: deprecate class based instantiation
Date: Mon, 10 Feb 2014 11:04:00 +0100
Message-Id: <1392026654-5343-7-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn users that class based instantiation is going away soon in favour
of more robust probing and faster bootup times.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Sonic Zhang <sonic.zhang@analog.com>
---

This patch is a suggestion. Looking for an ack by someone who actually uses
the driver.

 drivers/i2c/busses/i2c-bfin-twi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 3b9bd9a..c75f0e9 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -669,7 +669,7 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 	strlcpy(p_adap->name, pdev->name, sizeof(p_adap->name));
 	p_adap->algo = &bfin_twi_algorithm;
 	p_adap->algo_data = iface;
-	p_adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
+	p_adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD | I2C_CLASS_DEPRECATED;
 	p_adap->dev.parent = &pdev->dev;
 	p_adap->timeout = 5 * HZ;
 	p_adap->retries = 3;
-- 
1.8.5.1

