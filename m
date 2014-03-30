Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaC3XgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:36:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36478 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Julius Werner" <jwerner@chromium.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.656422235@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 167/200] usb: Add device quirk for Logitech HD Pro
 Webcams C920 and C930e
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -46,6 +46,10 @@ static const struct usb_device_id usb_qu
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech HD Pro Webcams C920 and C930e */
+	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x046d, 0x0843), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Logitech Quickcam Fusion */
 	{ USB_DEVICE(0x046d, 0x08c1), .driver_info = USB_QUIRK_RESET_RESUME },
 

