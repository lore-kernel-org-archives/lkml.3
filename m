Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3ELOZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:25:25 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34054 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3ELOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:25:22 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: a.zummo@towertech.it, akpm@linuxfoundation.org, ldewangan@nvidia.com
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH] rtc: tps6586x: device wakeup flags correction
Date: Sun, 12 May 2013 18:25:06 +0400
Message-Id: <1368368706-21261-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device_init_wakeup() instead of device_set_wakeup_capable() and move it
before rtc dev registering. This fixes issue with alarmtimer that checks wakeup
capability with device_may_wakeup() on device add.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/rtc/rtc-tps6586x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index 459c2ff..426901c 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -273,6 +273,8 @@ static int tps6586x_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	platform_set_drvdata(pdev, rtc);
 	rtc->rtc = devm_rtc_device_register(&pdev->dev, dev_name(&pdev->dev),
 				       &tps6586x_rtc_ops, THIS_MODULE);
@@ -292,7 +294,6 @@ static int tps6586x_rtc_probe(struct platform_device *pdev)
 		goto fail_rtc_register;
 	}
 	disable_irq(rtc->irq);
-	device_set_wakeup_capable(&pdev->dev, 1);
 	return 0;
 
 fail_rtc_register:
-- 
1.8.2.1

