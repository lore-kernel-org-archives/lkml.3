Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3EVX3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 19:29:11 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:52212 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3EVX3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 19:29:09 -0400
Message-ID: <519D54BE.1030409@gmail.com>
Date: Thu, 23 May 2013 03:29:02 +0400
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: a.zummo@towertech.it, akpm@linuxfoundation.org, ldewangan@nvidia.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH V2] rtc: tps6586x: device wakeup flags correction
References: <1368368706-21261-1-git-send-email-digetx@gmail.com> <20130522152204.d46057964fa06cc0d56f8e6b@linux-foundation.org>
In-Reply-To: <20130522152204.d46057964fa06cc0d56f8e6b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device_init_wakeup() instead of device_set_wakeup_capable() and move it
before rtc dev registering. This fixes alarmtimer not registered when tps6586x
rtc is the only wakeup compatible rtc in the system.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 V2: changed description

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
