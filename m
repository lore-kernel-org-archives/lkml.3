Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaGJLtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:49:36 -0400
Received: from sauhun.de ([89.238.76.85]:57098 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbaGJLq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:46:56 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/16] i2c: i2c-nomadik: Drop class based scanning to improve bootup time
Date: Thu, 10 Jul 2014 13:46:28 +0200
Message-Id: <1404992799-3705-9-git-send-email-wsa@the-dreams.de>
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
 drivers/i2c/busses/i2c-nomadik.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 0e55d85fd4ed..9ad038d223c4 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -1032,10 +1032,10 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	adap = &dev->adap;
 	adap->dev.of_node = np;
 	adap->dev.parent = &adev->dev;
-	adap->owner	= THIS_MODULE;
-	adap->class	= I2C_CLASS_HWMON | I2C_CLASS_SPD | I2C_CLASS_DEPRECATED;
-	adap->algo	= &nmk_i2c_algo;
-	adap->timeout	= msecs_to_jiffies(dev->timeout);
+	adap->owner = THIS_MODULE;
+	adap->class = I2C_CLASS_DEPRECATED;
+	adap->algo = &nmk_i2c_algo;
+	adap->timeout = msecs_to_jiffies(dev->timeout);
 	snprintf(adap->name, sizeof(adap->name),
 		 "Nomadik I2C at %pR", &adev->res);
 
-- 
2.0.0

