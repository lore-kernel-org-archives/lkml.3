Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3BFJYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:24:43 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:31885 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3BFJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:24:40 -0500
From: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
To: <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zihan@huawei.com>, <Lin.Lei@huawei.com>,
        <greg@kroah.com>, <neil.yi@huawei.com>, <wangyuhua@huawei.com>,
        <huqiao36@huawei.com>, <balbi@ti.com>, <mdharm-usb@one-eyed-alien.net>,
        <sebastian@breakpoint.cc>
Message-ID: <fe6feaa260b9.60b9fe6feaa2@huawei.com>
Date: Wed, 6 Feb 2013 17:24:12 +0800
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
MIME-Version: 1.0
Content-Language: zh-CN
Subject: [PATCH 1/1]linux-usb: fix the product IDs to be little endian
 in initializers.c
X-Accept-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi <huananhu@huawei.com>

1. The idProduct is little endian, so make the product ID's value to be little endian. Make no break on big endian processors.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
--------------------------------------------------------------------

diff -uprN linux-3.8-rc6_orig/drivers/usb/storage/initializers.c linux-3.8-rc6/drivers/usb/storage/initializers.c
--- linux-3.8-rc6_orig/drivers/usb/storage/initializers.c	2013-02-06 14:48:51.564355283 +0800
+++ linux-3.8-rc6/drivers/usb/storage/initializers.c	2013-02-06 15:11:40.925434289 +0800
@@ -152,12 +152,15 @@ static int usb_stor_huawei_dongles_pid(s
 	 * means the dongle in the single port mode,
 	 * and a switch command is required to be sent. */
 	if (idesc && idesc->bInterfaceNumber == 0) {
-		if ((idProduct == 0x1001)
-			|| (idProduct == 0x1003)
-			|| (idProduct == 0x1004)
-			|| (idProduct >= 0x1401 && idProduct <= 0x1500)
-			|| (idProduct >= 0x1505 && idProduct <= 0x1600)
-			|| (idProduct >= 0x1c02 && idProduct <= 0x2202)) {
+		if ((idProduct == cpu_to_le16(0x1001))
+			|| (idProduct == cpu_to_le16(0x1003))
+			|| (idProduct == cpu_to_le16(0x1004))
+			|| (idProduct >= cpu_to_le16(0x1401)
+				&& idProduct <= cpu_to_le16(0x1500))
+			|| (idProduct >= cpu_to_le16(0x1505)
+				&& idProduct <= cpu_to_le16(0x1600))
+			|| (idProduct >= cpu_to_le16(0x1c02)
+				&& idProduct <= cpu_to_le16(0x2202))) {
 			return 1;
 		}
 	}
@@ -169,7 +172,7 @@ int usb_stor_huawei_init(struct us_data
 	int result = 0;
 
 	if (usb_stor_huawei_dongles_pid(us)) {
-		if (us->pusb_dev->descriptor.idProduct >= 0x1446)
+		if (us->pusb_dev->descriptor.idProduct >= cpu_to_le16(0x1446))
 			result = usb_stor_huawei_scsi_init(us);
 		else
 			result = usb_stor_huawei_feature_init(us);
 

