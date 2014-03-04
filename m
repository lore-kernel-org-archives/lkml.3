Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaCDSxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:53:01 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38674 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaCDSw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:52:59 -0500
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oliver Neukum <oneukum@suse.de>, Luigi Semenzato <semenzato@chromium.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH 1/2] usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
Date: Tue,  4 Mar 2014 10:52:39 -0800
Message-Id: <1393959159-32693-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've encountered a rare issue when enumerating two Logitech webcams
after a reboot that doesn't power cycle the USB ports. They are spewing
random data (possibly some leftover UVC buffers) on the second
(full-sized) Get Configuration request of the enumeration phase. Since
the data is random this can potentially cause all kinds of odd behavior,
and since it occasionally happens multiple times (after the kernel
issues another reset due to the garbled configuration descriptor), it is
not always recoverable. Set the USB_DELAY_INIT quirk that seems to work
around the issue.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 8f37063..739ee8e 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -47,6 +47,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech HD Pro Webcams C920 and C930e */
+	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x046d, 0x0843), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Logitech Quickcam Fusion */
 	{ USB_DEVICE(0x046d, 0x08c1), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
1.8.3.2

