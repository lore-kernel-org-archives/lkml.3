Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbbA2KmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:42:25 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754829AbbA2JAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 173/176] USB: adutux: NULL dereferences on disconnect
Date: Wed, 28 Jan 2015 15:30:03 +0100
Message-Id: <ad8ec432bd1c7714f0b8bd6b13a8b79129412cf5.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fc625960edecfb57e62c2975d1f155155e28e6ba upstream.

Both "dev->udev" and "interface->dev" are NULL.  These printks are not
very interesting so I just deleted them.

Fixes: 03270634e242 ('USB: Add ADU support for Ontrak ADU devices')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/misc/adutux.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 3eaa83f05086..e2373f179522 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -815,15 +815,10 @@ static void adu_disconnect(struct usb_interface *interface)
 	usb_set_intfdata(interface, NULL);
 
 	/* if the device is not opened, then we clean up right now */
-	dev_dbg(&dev->udev->dev, "%s : open count %d\n",
-		__func__, dev->open_count);
 	if (!dev->open_count)
 		adu_delete(dev);
 
 	mutex_unlock(&adutux_mutex);
-
-	dev_info(&interface->dev, "ADU device adutux%d now disconnected\n",
-		 (minor - ADU_MINOR_BASE));
 }
 
 /* usb specific object needed to register this driver with the usb subsystem */
-- 
2.2.2

