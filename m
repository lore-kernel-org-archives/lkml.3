Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454Ab3ICQig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:38:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46415 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab3ICQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 14/58] USB: adutux: fix big-endian device-type reporting
Date: Tue,  3 Sep 2013 09:23:18 -0700
Message-Id: <1378225442-20654-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d482b9d558602a9cacab063b1c8779f9b5214da7 upstream.

Make sure the reported device-type on big-endian machines is the same as
on little-endian ones.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.1.2

