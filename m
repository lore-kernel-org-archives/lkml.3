Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3H0IMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:12:47 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:55946 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3H0ILG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:11:06 -0400
Message-ID: <521C5EE9.8080607@huawei.com>
Date: Tue, 27 Aug 2013 16:10:17 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>
CC: USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 1/4] usb: fotg210-udc: use platform_{get,set}_drvdata()
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
 drivers/usb/gadget/fotg210-udc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/fotg210-udc.c b/drivers/usb/gadget/fotg210-udc.c
index 10cd18d..32db2ee 100644
--- a/drivers/usb/gadget/fotg210-udc.c
+++ b/drivers/usb/gadget/fotg210-udc.c
@@ -1076,7 +1076,7 @@ static struct usb_gadget_ops fotg210_gadget_ops = {

 static int fotg210_udc_remove(struct platform_device *pdev)
 {
-	struct fotg210_udc *fotg210 = dev_get_drvdata(&pdev->dev);
+	struct fotg210_udc *fotg210 = platform_get_drvdata(pdev);

 	usb_del_gadget_udc(&fotg210->gadget);
 	iounmap(fotg210->reg);
@@ -1134,7 +1134,7 @@ static int fotg210_udc_probe(struct platform_device *pdev)

 	spin_lock_init(&fotg210->lock);

-	dev_set_drvdata(&pdev->dev, fotg210);
+	platform_set_drvdata(pdev, fotg210);

 	fotg210->gadget.ops = &fotg210_gadget_ops;

-- 
1.7.1

