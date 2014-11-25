Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaKYMDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:03:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58067 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaKYKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 022/254] USB: quirks: enable device-qualifier quirk for Elan Touchscreen
Date: Tue, 25 Nov 2014 10:36:12 +0000
Message-Id: <1416912004-5928-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 5144d11d032c..41c934ffba0a 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -93,6 +93,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Elan Touchscreen */
+	{ USB_DEVICE(0x04f3, 0x0089), .driver_info =
+			USB_QUIRK_DEVICE_QUALIFIER },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
2.1.0

