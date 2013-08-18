Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3HRUln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:41:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3HRUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 34/45] USB: keyspan: fix null-deref at disconnect and release
Date: Sun, 18 Aug 2013 13:36:23 -0700
Message-Id: <20130818203623.360853531@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ff8a43c10f1440f07a5faca0c1556921259f7f76 upstream.

Make sure to fail properly if the device is not accepted during attach
in order to avoid null-pointer derefs (of missing interface private
data) at disconnect or release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2315,7 +2315,7 @@ static int keyspan_startup(struct usb_se
 	if (d_details == NULL) {
 		dev_err(&serial->dev->dev, "%s - unknown product id %x\n",
 		    __func__, le16_to_cpu(serial->dev->descriptor.idProduct));
-		return 1;
+		return -ENODEV;
 	}
 
 	/* Setup private data for serial driver */


