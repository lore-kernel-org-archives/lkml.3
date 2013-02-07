Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3BGHcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:32:32 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:1231 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3BGHcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:32:31 -0500
From: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
To: <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zihan@huawei.com>, <Lin.Lei@huawei.com>,
        <greg@kroah.com>, <neil.yi@huawei.com>, <wangyuhua@huawei.com>,
        <huqiao36@huawei.com>, <balbi@ti.com>, <mdharm-usb@one-eyed-alien.net>,
        <sebastian@breakpoint.cc>
Message-ID: <fe8ad35c629c.629cfe8ad35c@huawei.com>
Date: Thu, 7 Feb 2013 15:32:07 +0800
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
MIME-Version: 1.0
Content-Language: zh-CN
Subject: [PATCH 1/1]linux-usb: fix the idProduct value to be compatible
 with current CPU in initializers.c
X-Accept-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: fangxiaozhi <huananhu@huawei.com>

1. The idProduct is little endian, so make sure its value to be compatible with the current CPU. Make no break on big endian processors.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
--------------------------------------------------------------------
diff -uprN linux-3.8-rc6_orig/drivers/usb/storage/initializers.c linux-3.8-rc6/drivers/usb/storage/initializers.c
--- linux-3.8-rc6_orig/drivers/usb/storage/initializers.c	2013-02-06 14:48:51.564355283 +0800
+++ linux-3.8-rc6/drivers/usb/storage/initializers.c	2013-02-07 15:29:59.929482630 +0800
@@ -147,7 +147,7 @@ static int usb_stor_huawei_dongles_pid(s
 	int idProduct;
 
 	idesc = &us->pusb_intf->cur_altsetting->desc;
-	idProduct = us->pusb_dev->descriptor.idProduct;
+	idProduct = le16_to_cpu(us->pusb_dev->descriptor.idProduct);
 	/* The first port is CDROM,
 	 * means the dongle in the single port mode,
 	 * and a switch command is required to be sent. */
@@ -169,7 +169,7 @@ int usb_stor_huawei_init(struct us_data
 	int result = 0;
 
 	if (usb_stor_huawei_dongles_pid(us)) {
-		if (us->pusb_dev->descriptor.idProduct >= 0x1446)
+		if (le16_to_cpu(us->pusb_dev->descriptor.idProduct) >= 0x1446)
 			result = usb_stor_huawei_scsi_init(us);
 		else
 			result = usb_stor_huawei_feature_init(us);

