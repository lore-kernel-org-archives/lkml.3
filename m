Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab3BZX7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:59:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab3BZX7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        fangxiaozhi <huananhu@huawei.com>
Subject: [ 52/53] USB: storage: properly handle the endian issues of idProduct
Date: Tue, 26 Feb 2013 15:58:21 -0800
Message-Id: <20130226235625.245541860@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: fangxiaozhi <huananhu@huawei.com>

commit cd060956c5e97931c3909e4a808508469c0bb9f6 upstream.

1. The idProduct is little endian, so make sure its value to be
compatible with the current CPU. Make no break on big endian processors.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/initializers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
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


