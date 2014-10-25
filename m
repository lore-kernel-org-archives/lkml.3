Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaJYS64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:58:56 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48129 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaJYS6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:58:52 -0400
Message-ID: <544B5663.1000102@gmail.com>
Date: Sat, 25 Oct 2014 09:50:59 +0200
From: =?UTF-8?B?UHLDqWRob21tZSBQaGlsaXBwZQ==?= <predhomme.p@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: jkosina@suse.cz
Subject: PATCH : add support for HuiJia USB Gamepad connector (0e8f:1006 and
 0e8f:3010)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create each gamepad as a separate joystick
Both device (1006 is for Sega Saturn controllers, 3010 is for Sony
Playstation 1/2 controllers) work the same as 0e8f:3013 (which is for
Nintendo 64 controllers), so i used this device as reference to make my
patch.
Work with kernel 3.14, 3.15, 3.16, 3.17.

Signed-off-by: Philippe Prédhomme <predhomme.p@gmail.com>

diff -git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -362,6 +362,8 @@
 
 #define USB_VENDOR_ID_GREENASIA        0x0e8f
 #define USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD    0x3013
+#define USB_DEVICE_ID_GREENASIA_DUAL_SS_JOYPAD 0x1006
+#define USB_DEVICE_ID_GREENASIA_DUAL_PS_JOYPAD 0x3010
 
 #define USB_VENDOR_ID_GRETAGMACBETH    0x0971
 #define USB_DEVICE_ID_GRETAGMACBETH_HUEY    0x2005
diff -git a/drivers/hid/usbhid/hid-quirks.c
b/drivers/hid/usbhid/hid-quirks.c
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -50,6 +50,8 @@ static const struct hid_blacklist {
     { USB_VENDOR_ID_EMS, USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II,
HID_QUIRK_MULTI_INPUT },
     { USB_VENDOR_ID_ETURBOTOUCH, USB_DEVICE_ID_ETURBOTOUCH,
HID_QUIRK_MULTI_INPUT },
     { USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD,
HID_QUIRK_MULTI_INPUT },
+    { USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_SS_JOYPAD,
HID_QUIRK_MULTI_INPUT },
+    { USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_PS_JOYPAD,
HID_QUIRK_MULTI_INPUT },
     { USB_VENDOR_ID_PANTHERLORD,
USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT |
HID_QUIRK_SKIP_OUTPUT_REPORTS },
     { USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII,
HID_QUIRK_MULTI_INPUT },
     { USB_VENDOR_ID_TOUCHPACK, USB_DEVICE_ID_TOUCHPACK_RTS,
HID_QUIRK_MULTI_INPUT },

