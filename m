Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab3IBJKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:10:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37695 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3IBIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 16/58] USB: adutux: fix big-endian device-type reporting
Date: Mon,  2 Sep 2013 09:54:01 +0100
Message-Id: <1378112083-9475-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d482b9d558602a9cacab063b1c8779f9b5214da7 upstream.

Make sure the reported device-type on big-endian machines is the same as
on little-endian ones.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/misc/adutux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 284b854..14d9142 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -829,7 +829,7 @@ static int adu_probe(struct usb_interface *interface,
 
 	/* let the user know what node this device is now attached to */
 	dev_info(&interface->dev, "ADU%d %s now attached to /dev/usb/adutux%d\n",
-		 udev->descriptor.idProduct, dev->serial_number,
+		 le16_to_cpu(udev->descriptor.idProduct), dev->serial_number,
 		 (dev->minor - ADU_MINOR_BASE));
 exit:
 	dbg(2," %s : leave, return value %p (dev)", __func__, dev);
-- 
1.8.3.2

