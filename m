Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3H0ILR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:11:17 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:55992 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab3H0ILI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:11:08 -0400
Message-ID: <521C5EEE.1080505@huawei.com>
Date: Tue, 27 Aug 2013 16:10:22 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>,
        USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/4] usb: r8a66597-hcd: use platform_{get,set}_drvdata()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/r8a66597-hcd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
index a6fd8f5..777790a 100644
--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -2393,7 +2393,7 @@ static const struct dev_pm_ops r8a66597_dev_pm_ops = {

 static int r8a66597_remove(struct platform_device *pdev)
 {
-	struct r8a66597		*r8a66597 = dev_get_drvdata(&pdev->dev);
+	struct r8a66597		*r8a66597 = platform_get_drvdata(pdev);
 	struct usb_hcd		*hcd = r8a66597_to_hcd(r8a66597);

 	del_timer_sync(&r8a66597->rh_timer);
@@ -2466,7 +2466,7 @@ static int r8a66597_probe(struct platform_device *pdev)
 	}
 	r8a66597 = hcd_to_r8a66597(hcd);
 	memset(r8a66597, 0, sizeof(struct r8a66597));
-	dev_set_drvdata(&pdev->dev, r8a66597);
+	platform_set_drvdata(pdev, r8a66597);
 	r8a66597->pdata = pdev->dev.platform_data;
 	r8a66597->irq_sense_low = irq_trigger == IRQF_TRIGGER_LOW;

-- 
1.7.1

