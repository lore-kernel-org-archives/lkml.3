Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbbAXUVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 15:21:04 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40390 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbAXUVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 15:21:01 -0500
Date: Sat, 24 Jan 2015 22:20:53 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, tapaswenipathak@gmail.com,
        thomas@grouk.net, sudipm.mukherjee@gmail.com,
        rickard_strandqvist@spectrumdigital.se, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: fix Prefer [subsystem eg:
 netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to
 printk(KERN_INFO ...
Message-ID: <20150124202053.GA1641@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:
fix Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then
dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

netdev_info was used since it is a network subsystem

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/rtl8712/usb_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 7d0d171..7748a75 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -366,7 +366,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	struct net_device *pnetdev;
 	struct usb_device *udev;
 
-	printk(KERN_INFO "r8712u: Staging version\n");
+	netdev_info(pnetdev, "r8712u: Staging version\n");
 	/* In this probe function, O.S. will provide the usb interface pointer
 	 * to driver. We have to increase the reference count of the usb device
 	 * structure by using the usb_get_dev function.
-- 
1.7.9.5

