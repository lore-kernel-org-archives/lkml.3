Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaCaNYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:24:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35616 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaCaNXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 23/71] usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
Date: Mon, 31 Mar 2014 14:22:29 +0100
Message-Id: <1396272197-13394-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Werner <jwerner@chromium.org>

commit e0429362ab15c46ea4d64c3f8c9e0933e48a143a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 987d3ef..a5545de 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -41,6 +41,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech HD Pro Webcams C920 and C930e */
+	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x046d, 0x0843), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Logitech Webcam C200 */
 	{ USB_DEVICE(0x046d, 0x0802), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
1.9.1

