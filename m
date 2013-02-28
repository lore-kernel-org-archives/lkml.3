Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533Ab3B1PRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:17:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab3B1OrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: fangxiaozhi <huananhu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 037/139] USB: storage: properly handle the endian issues of idProduct
Date: Thu, 28 Feb 2013 14:43:07 +0000
Message-Id: <1362062689-2567-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: fangxiaozhi <huananhu@huawei.com>

commit cd060956c5e97931c3909e4a808508469c0bb9f6 upstream.

1. The idProduct is little endian, so make sure its value to be
compatible with the current CPU. Make no break on big endian processors.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/initializers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
index 16b0bf0..7ab9046 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -147,7 +147,7 @@ static int usb_stor_huawei_dongles_pid(struct us_data *us)
 	int idProduct;
 
 	idesc = &us->pusb_intf->cur_altsetting->desc;
-	idProduct = us->pusb_dev->descriptor.idProduct;
+	idProduct = le16_to_cpu(us->pusb_dev->descriptor.idProduct);
 	/* The first port is CDROM,
 	 * means the dongle in the single port mode,
 	 * and a switch command is required to be sent. */
@@ -169,7 +169,7 @@ int usb_stor_huawei_init(struct us_data *us)
 	int result = 0;
 
 	if (usb_stor_huawei_dongles_pid(us)) {
-		if (us->pusb_dev->descriptor.idProduct >= 0x1446)
+		if (le16_to_cpu(us->pusb_dev->descriptor.idProduct) >= 0x1446)
 			result = usb_stor_huawei_scsi_init(us);
 		else
 			result = usb_stor_huawei_feature_init(us);
-- 
1.8.1.2

