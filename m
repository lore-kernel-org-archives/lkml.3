Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaGJLrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:47:09 -0400
Received: from sauhun.de ([89.238.76.85]:57113 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaGJLrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:47:03 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] i2c: i2c-sirf: Drop class based scanning to improve bootup time
Date: Thu, 10 Jul 2014 13:46:33 +0200
Message-Id: <1404992799-3705-14-git-send-email-wsa@the-dreams.de>
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
 drivers/i2c/busses/i2c-sirf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-sirf.c b/drivers/i2c/busses/i2c-sirf.c
index a3216defc1d3..b1336d5f0531 100644
--- a/drivers/i2c/busses/i2c-sirf.c
+++ b/drivers/i2c/busses/i2c-sirf.c
@@ -311,7 +311,7 @@ static int i2c_sirfsoc_probe(struct platform_device *pdev)
 		goto out;
 	}
 	adap = &siic->adapter;
-	adap->class = I2C_CLASS_HWMON | I2C_CLASS_DEPRECATED;
+	adap->class = I2C_CLASS_DEPRECATED;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	siic->base = devm_ioremap_resource(&pdev->dev, mem_res);
-- 
2.0.0

