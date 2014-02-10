Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaBJKEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:04:40 -0500
Received: from sauhun.de ([89.238.76.85]:38549 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaBJKEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:34 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/17] i2c: i2c-davinci: deprecate class based instantiation
Date: Mon, 10 Feb 2014 11:04:01 +0100
Message-Id: <1392026654-5343-8-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn users that class based instantiation is going away soon in favour
of more robust probing and faster bootup times.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
---

This patch is a suggestion. Looking for an ack by someone who actually uses
the driver.

 drivers/i2c/busses/i2c-davinci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index af0b583..389bc68 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -712,7 +712,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	adap = &dev->adapter;
 	i2c_set_adapdata(adap, dev);
 	adap->owner = THIS_MODULE;
-	adap->class = I2C_CLASS_HWMON;
+	adap->class = I2C_CLASS_HWMON | I2C_CLASS_DEPRECATED;
 	strlcpy(adap->name, "DaVinci I2C adapter", sizeof(adap->name));
 	adap->algo = &i2c_davinci_algo;
 	adap->dev.parent = &pdev->dev;
-- 
1.8.5.1

