Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbaKLBbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:31:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbaKLBbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:31:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Drew Von Spreecken <drewvs@gmail.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.17 223/319] USB: quirks: enable device-qualifier quirk for Elan Touchscreen
Date: Wed, 12 Nov 2014 10:16:01 +0900
Message-Id: <20141112011029.690113790@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit c68929f75dfcb6354918862b91b5778585de1fa5 upstream.

Enable device-qualifier quirk for Elan Touchscreen, which often fails to
handle requests for the device_descriptor.

Note that the device sometimes do respond properly with a Request Error
(three times as USB core retries), but usually fails to respond at all.
When this happens any further descriptor requests also fails, for
example:

[ 1528.688934] usb 2-7: new full-speed USB device number 4 using xhci_hcd
[ 1530.945588] usb 2-7: unable to read config index 0 descriptor/start: -71
[ 1530.945592] usb 2-7: can't read configurations, error -71

This has been observed repeating for over a minute before eventual
successful enumeration.

Reported-by: Drew Von Spreecken <drewvs@gmail.com>
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -93,6 +93,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Elan Touchscreen */
+	{ USB_DEVICE(0x04f3, 0x0089), .driver_info =
+			USB_QUIRK_DEVICE_QUALIFIER },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 


