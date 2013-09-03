Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab3ICQhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:37:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46432 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3ICQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 19/58] usb: add two quirky touchscreen
Date: Tue,  3 Sep 2013 09:23:23 -0700
Message-Id: <1378225442-20654-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 304ab4ab079a8ed03ce39f1d274964a532db036b upstream.

These devices tend to become unresponsive after S3

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/core/quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index e14346a..be54c80 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -78,6 +78,12 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04d8, 0x000c), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* CarrolTouch 4000U */
+	{ USB_DEVICE(0x04e7, 0x0009), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* CarrolTouch 4500U */
+	{ USB_DEVICE(0x04e7, 0x0030), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
-- 
1.8.1.2

