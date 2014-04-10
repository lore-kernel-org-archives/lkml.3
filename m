Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935209AbaDJEBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:01:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934867AbaDJDWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 080/134] USB: adutux: fix big-endian device-type reporting
Date: Wed,  9 Apr 2014 20:23:16 -0700
Message-Id: <20140410032310.263759408@linuxfoundation.org>
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

commit d482b9d558602a9cacab063b1c8779f9b5214da7 upstream.

Make sure the reported device-type on big-endian machines is the same as
on little-endian ones.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/adutux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -829,7 +829,7 @@ static int adu_probe(struct usb_interfac
 
 	/* let the user know what node this device is now attached to */
 	dev_info(&interface->dev, "ADU%d %s now attached to /dev/usb/adutux%d\n",
-		 udev->descriptor.idProduct, dev->serial_number,
+		 le16_to_cpu(udev->descriptor.idProduct), dev->serial_number,
 		 (dev->minor - ADU_MINOR_BASE));
 exit:
 	dbg(2," %s : leave, return value %p (dev)", __func__, dev);


