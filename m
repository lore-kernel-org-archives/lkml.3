Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbaDJEAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:00:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934642AbaDJDWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 082/134] USB: keyspan: fix null-deref at disconnect and release
Date: Wed,  9 Apr 2014 20:23:18 -0700
Message-Id: <20140410032310.480963970@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ff8a43c10f1440f07a5faca0c1556921259f7f76 upstream.

Make sure to fail properly if the device is not accepted during attach
in order to avoid null-pointer derefs (of missing interface private
data) at disconnect or release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2486,7 +2486,7 @@ static int keyspan_startup(struct usb_se
 	if (d_details == NULL) {
 		dev_err(&serial->dev->dev, "%s - unknown product id %x\n",
 		    __func__, le16_to_cpu(serial->dev->descriptor.idProduct));
-		return 1;
+		return -ENODEV;
 	}
 
 	/* Setup private data for serial driver */


