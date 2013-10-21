Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3JUI5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:57:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39877 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578Ab3JUIxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "Vasily Titskiy" <qehgt0@gmail.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.650541334@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 137/149] HID: usbhid: quirk for N-Trig DuoSense Touch
 Screen
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Titskiy <qehgt0@gmail.com>

commit 9e0bf92c223dabe0789714f8f85f6e26f8f9cda4 upstream.

The DuoSense touchscreen device causes a 10 second timeout. This fix
removes the delay.

Signed-off-by: Vasily Titskiy <qehgt0@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -581,6 +581,7 @@
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16   0x0012
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17   0x0013
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18   0x0014
+#define USB_DEVICE_ID_NTRIG_DUOSENSE 0x1500
 
 #define USB_VENDOR_ID_ONTRAK		0x0a07
 #define USB_DEVICE_ID_ONTRAK_ADU100	0x0064
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -99,6 +99,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
+
 	{ 0, 0 }
 };
 

