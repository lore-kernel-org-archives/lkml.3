Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab3HRUfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:35:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab3HRUfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>
Subject: [ 30/45] usb: add two quirky touchscreen
Date: Sun, 18 Aug 2013 13:36:19 -0700
Message-Id: <20130818203623.089430559@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 304ab4ab079a8ed03ce39f1d274964a532db036b upstream.

These devices tend to become unresponsive after S3

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -78,6 +78,12 @@ static const struct usb_device_id usb_qu
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


