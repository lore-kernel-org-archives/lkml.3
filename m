Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab3H3DX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:23:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26587 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3H3DXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:23:55 -0400
Message-ID: <52201023.40409@huawei.com>
Date: Fri, 30 Aug 2013 11:23:15 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>,
        USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 2/4] usb: r8a66597-hcd: use platform_{get,set}_drvdata()
References: <521C5EEE.1080505@huawei.com> <20130828043607.GA21756@kroah.com>
In-Reply-To: <20130828043607.GA21756@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &of->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/r8a66597-hcd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

rebase on usb-next tree

diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
index a9eef68..2ad004a 100644
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
 	r8a66597->pdata = dev_get_platdata(&pdev->dev);
 	r8a66597->irq_sense_low = irq_trigger == IRQF_TRIGGER_LOW;

-- 
1.7.1


