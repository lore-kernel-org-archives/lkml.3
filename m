Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887Ab3GWSCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:02:45 -0400
Received: from sauhun.de ([89.238.76.85]:58708 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757693Ab3GWSCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:02:43 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH 06/27] drivers/i2c/busses: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:39 +0200
Message-Id: <1374602524-3398-7-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/i2c/busses/i2c-stu300.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
index d1a6b20..ded21cf 100644
--- a/drivers/i2c/busses/i2c-stu300.c
+++ b/drivers/i2c/busses/i2c-stu300.c
@@ -884,9 +884,6 @@ stu300_probe(struct platform_device *pdev)
 
 	dev->pdev = pdev;
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
 	dev->virtbase = devm_ioremap_resource(&pdev->dev, res);
 	dev_dbg(&pdev->dev, "initialize bus device I2C%d on virtual "
 		"base %p\n", bus_nr, dev->virtbase);
-- 
1.7.10.4

