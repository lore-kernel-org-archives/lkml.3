Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3CDDvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:51:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33112 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757131Ab3CDDoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:38 -0500
Message-Id: <20130304033711.631839009@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:48 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, fangxiaozhi <huananhu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 041/153] USB: storage: properly handle the endian issues of idProduct
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: fangxiaozhi <huananhu@huawei.com>

commit cd060956c5e97931c3909e4a808508469c0bb9f6 upstream.

1. The idProduct is little endian, so make sure its value to be
compatible with the current CPU. Make no break on big endian processors.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


