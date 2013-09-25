Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab3IYA1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:27:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab3IYAU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vasily Titskiy <qehgt0@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 083/117] HID: usbhid: quirk for N-Trig DuoSense Touch Screen
Date: Tue, 24 Sep 2013 17:19:09 -0700
Message-Id: <20130925001750.023269911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Titskiy <qehgt0@gmail.com>

commit 9e0bf92c223dabe0789714f8f85f6e26f8f9cda4 upstream.

The DuoSense touchscreen device causes a 10 second timeout. This fix
removes the delay.

Signed-off-by: Vasily Titskiy <qehgt0@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/usbhid/hid-quirks.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -659,6 +659,7 @@
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16   0x0012
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17   0x0013
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18   0x0014
+#define USB_DEVICE_ID_NTRIG_DUOSENSE 0x1500
 
 #define USB_VENDOR_ID_ONTRAK		0x0a07
 #define USB_DEVICE_ID_ONTRAK_ADU100	0x0064
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -109,6 +109,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X, HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
+
 	{ 0, 0 }
 };
 


