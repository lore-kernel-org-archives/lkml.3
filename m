Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3LBTgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:36:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3LBTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Elias Vanderstuyft <Elias.vds@gmail.com>,
        Anssi Hannula <anssi.hannula@iki.fi>, Simon Wood <simon@mungewell.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 177/212] HID: logitech - lg2ff: Add IDs for Formula Vibration Feedback Wheel
Date: Mon,  2 Dec 2013 11:16:08 -0800
Message-Id: <20131202191308.068246575@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elias Vanderstuyft <Elias.vds@gmail.com>

commit bd04363d3990c0727b7512a79a08c68436878bb0 upstream.

Add USB IDs for Logitech Formula Vibration Feedback Wheel (046d:ca04).

The lg2ff force feedback subdriver is used for vibration and
HID_GD_MULTIAXIS is set to avoid deadzone like other Logitech wheels.

Kconfig description etc are also updated accordingly.

Signed-off-by: Elias Vanderstuyft <Elias.vds@gmail.com>
[anssi.hannula@iki.fi: added description and CCs]
Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Simon Wood <simon@mungewell.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/Kconfig     |    8 +++++---
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-ids.h   |    1 +
 drivers/hid/hid-lg.c    |    3 +++
 drivers/hid/hid-lg2ff.c |    2 +-
 5 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -369,12 +369,14 @@ config LOGITECH_FF
 	  force feedback.
 
 config LOGIRUMBLEPAD2_FF
-	bool "Logitech RumblePad/Rumblepad 2 force feedback support"
+	bool "Logitech force feedback support (variant 2)"
 	depends on HID_LOGITECH
 	select INPUT_FF_MEMLESS
 	help
-	  Say Y here if you want to enable force feedback support for Logitech
-	  RumblePad and Rumblepad 2 devices.
+	  Say Y here if you want to enable force feedback support for:
+	  - Logitech RumblePad
+	  - Logitech Rumblepad 2
+	  - Logitech Formula Vibration Feedback Wheel
 
 config LOGIG940_FF
 	bool "Logitech Flight System G940 force feedback support"
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1754,6 +1754,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_FLIGHT_SYSTEM_G940) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_VIBRATION_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFP_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFGT_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -576,6 +576,7 @@
 #define USB_DEVICE_ID_DINOVO_EDGE	0xc714
 #define USB_DEVICE_ID_DINOVO_MINI	0xc71f
 #define USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2	0xca03
+#define USB_DEVICE_ID_LOGITECH_VIBRATION_WHEEL	0xca04
 
 #define USB_VENDOR_ID_LUMIO		0x202e
 #define USB_DEVICE_ID_CRYSTALTOUCH	0x0006
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -492,6 +492,7 @@ static int lg_input_mapped(struct hid_de
 		case USB_DEVICE_ID_LOGITECH_G27_WHEEL:
 		case USB_DEVICE_ID_LOGITECH_WII_WHEEL:
 		case USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2:
+		case USB_DEVICE_ID_LOGITECH_VIBRATION_WHEEL:
 			field->application = HID_GD_MULTIAXIS;
 			break;
 		default:
@@ -639,6 +640,8 @@ static const struct hid_device_id lg_dev
 		.driver_data = LG_NOGET | LG_FF4 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2),
 		.driver_data = LG_FF4 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_VIBRATION_WHEEL),
+		.driver_data = LG_FF2 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL),
 		.driver_data = LG_FF4 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DFGT_WHEEL),
--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -95,7 +95,7 @@ int lg2ff_init(struct hid_device *hid)
 
 	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 
-	hid_info(hid, "Force feedback for Logitech RumblePad/Rumblepad 2 by Anssi Hannula <anssi.hannula@gmail.com>\n");
+	hid_info(hid, "Force feedback for Logitech variant 2 rumble devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
 }


