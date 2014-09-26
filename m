Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaIZK7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:59:19 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43026 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaIZK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:58:36 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 2/6] mfd: rtsx_usb: fix platform device-id collision
Date: Fri, 26 Sep 2014 12:55:29 +0200
Message-Id: <1411728933-13351-3-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1411728933-13351-1-git-send-email-johan@kernel.org>
References: <1411728933-13351-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hot-pluggable multi-function devices should use PLATFORM_DEVID_AUTO to
avoid name collisions on the platform bus.

This driver currently uses the USB-device address as an id. This makes
name collisions unlikely, but it could still happen if two devices are
connected to separate buses and gets assigned the same address.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/mfd/rtsx_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 71f387ce8cbd..78073e4b87e4 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -647,7 +647,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 	/* initialize USB SG transfer timer */
 	setup_timer(&ucr->sg_timer, rtsx_usb_sg_timed_out, (unsigned long) ucr);
 
-	ret = mfd_add_devices(&intf->dev, usb_dev->devnum, rtsx_usb_cells,
+	ret = mfd_add_devices(&intf->dev, PLATFORM_DEVID_AUTO, rtsx_usb_cells,
 			ARRAY_SIZE(rtsx_usb_cells), NULL, 0, NULL);
 	if (ret)
 		goto out_init_fail;
-- 
1.8.5.5

