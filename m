Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946388Ab3BHOi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:38:28 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:52756 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3BHOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:38:26 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] HID: Kconfig: Remove explicit transport layer dependencies
Date: Fri,  8 Feb 2013 15:37:32 +0100
Message-Id: <1360334256-22127-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most HID drivers (rightfully) only depend on the HID bus, not the
specific transport layer. Remove such dependencies where applicable.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/Kconfig          | 66 ++++++++++++++++++++++----------------------
 drivers/hid/hid-apple.c      |  1 -
 drivers/hid/hid-magicmouse.c |  1 -
 drivers/hid/hid-speedlink.c  |  2 --
 4 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 69ab7c2..581ca9f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -92,7 +92,7 @@ menu "Special HID drivers"
 
 config HID_A4TECH
 	tristate "A4 tech mice" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
@@ -113,7 +113,7 @@ config HID_ACRUX_FF
 
 config HID_APPLE
 	tristate "Apple {i,Power,Mac}Books" if EXPERT
-	depends on (USB_HID || BT_HIDP)
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for some Apple devices which less or more break
@@ -124,27 +124,27 @@ config HID_APPLE
 
 config HID_AUREAL
 	tristate "Aureal"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Aureal Cy se W-01RN Remote Controller and other Aureal derived remotes.
 
 config HID_BELKIN
 	tristate "Belkin Flip KVM and Wireless keyboard" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
 config HID_CHERRY
 	tristate "Cherry Cymotion keyboard" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for Cherry Cymotion keyboard.
 
 config HID_CHICONY
 	tristate "Chicony Tactical pad" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for Chicony Tactical pad.
@@ -166,7 +166,7 @@ config HID_PRODIKEYS
 
 config HID_CYPRESS
 	tristate "Cypress mouse and barcode readers" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for cypress mouse and barcode readers.
@@ -202,13 +202,13 @@ config HID_EMS_FF
 
 config HID_ELECOM
 	tristate "ELECOM BM084 bluetooth mouse"
-	depends on BT_HIDP
+	depends on HID
 	---help---
 	Support for the ELECOM BM084 (bluetooth mouse).
 
 config HID_EZKEY
 	tristate "Ezkey BTC 8193 keyboard" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for Ezkey BTC 8193 keyboard.
@@ -231,7 +231,7 @@ config HOLTEK_FF
 
 config HID_KEYTOUCH
 	tristate "Keytouch HID devices"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Keytouch HID devices not fully compliant with
 	the specification. Currently supported:
@@ -249,25 +249,25 @@ config HID_KYE
 
 config HID_UCLOGIC
 	tristate "UC-Logic"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for UC-Logic tablets.
 
 config HID_WALTOP
 	tristate "Waltop"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Waltop tablets.
 
 config HID_GYRATION
 	tristate "Gyration remote control"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Gyration remote control.
 
 config HID_ICADE
 	tristate "ION iCade arcade controller"
-	depends on BT_HIDP
+	depends on HID
 	---help---
 	Support for the ION iCade arcade controller to work as a joystick.
 
@@ -276,20 +276,20 @@ config HID_ICADE
 
 config HID_TWINHAN
 	tristate "Twinhan IR remote control"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Twinhan IR remote control.
 
 config HID_KENSINGTON
 	tristate "Kensington Slimblade Trackball" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for Kensington Slimblade Trackball.
 
 config HID_LCPOWER
 	tristate "LC-Power"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for LC-Power RC1000MCE RF remote control.
 
@@ -308,7 +308,7 @@ config HID_LENOVO_TPKBD
 
 config HID_LOGITECH
 	tristate "Logitech devices" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
@@ -374,7 +374,7 @@ config LOGIWHEELS_FF
 
 config HID_MAGICMOUSE
 	tristate "Apple MagicMouse multi-touch support"
-	depends on BT_HIDP
+	depends on HID
 	---help---
 	Support for the Apple Magic Mouse multi-touch.
 
@@ -383,14 +383,14 @@ config HID_MAGICMOUSE
 
 config HID_MICROSOFT
 	tristate "Microsoft non-fully HID-compliant devices" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for Microsoft devices that are not fully compliant with HID standard.
 
 config HID_MONTEREY
 	tristate "Monterey Genius KB29E keyboard" if EXPERT
-	depends on USB_HID
+	depends on HID
 	default !EXPERT
 	---help---
 	Support for Monterey Genius KB29E.
@@ -445,7 +445,7 @@ config HID_NTRIG
 
 config HID_ORTEK
 	tristate "Ortek PKB-1700/WKB-2000/Skycable wireless keyboard and mouse trackpad"
-	depends on USB_HID
+	depends on HID
 	---help---
 	There are certain devices which have LogicalMaximum wrong in the keyboard
 	usage page of their report descriptor. The most prevailing ones so far
@@ -473,7 +473,7 @@ config PANTHERLORD_FF
 
 config HID_PETALYNX
 	tristate "Petalynx Maxter remote control"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Petalynx Maxter remote control.
 
@@ -545,14 +545,14 @@ config HID_PICOLCD_CIR
 
 config HID_PRIMAX
 	tristate "Primax non-fully HID-compliant devices"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Primax devices that are not fully compliant with the
 	HID standard.
 
 config HID_PS3REMOTE
 	tristate "Sony PS3 BD Remote Control"
-	depends on BT_HIDP
+	depends on HID
 	---help---
 	Support for the Sony PS3 Blue-ray Disk Remote Control and Logitech
 	Harmony Adapter for PS3, which connect over Bluetooth.
@@ -569,7 +569,7 @@ config HID_ROCCAT
 
 config HID_SAITEK
 	tristate "Saitek non-fully HID-compliant devices"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Saitek devices that are not fully compliant with the
 	HID standard.
@@ -578,7 +578,7 @@ config HID_SAITEK
 
 config HID_SAMSUNG
 	tristate "Samsung InfraRed remote control or keyboards"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Samsung InfraRed remote control or keyboards.
 
@@ -604,7 +604,7 @@ config HID_STEELSERIES
 
 config HID_SUNPLUS
 	tristate "Sunplus wireless desktop"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Sunplus wireless desktop.
 
@@ -650,13 +650,13 @@ config SMARTJOYPLUS_FF
 
 config HID_TIVO
 	tristate "TiVo Slide Bluetooth remote control support"
-	depends on (USB_HID || BT_HIDP)
+	depends on HID
 	---help---
 	Say Y if you have a TiVo Slide Bluetooth remote control.
 
 config HID_TOPSEED
 	tristate "TopSeed Cyberlink, BTC Emprex, Conceptronic remote control support"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Say Y if you have a TopSeed Cyberlink or BTC Emprex or Conceptronic
 	CLLRCMCE remote control.
@@ -679,7 +679,7 @@ config THRUSTMASTER_FF
 
 config HID_WACOM
 	tristate "Wacom Bluetooth devices support"
-	depends on BT_HIDP
+	depends on HID
 	depends on LEDS_CLASS
 	select POWER_SUPPLY
 	---help---
@@ -687,7 +687,7 @@ config HID_WACOM
 
 config HID_WIIMOTE
 	tristate "Nintendo Wii Remote support"
-	depends on BT_HIDP
+	depends on HID
 	depends on LEDS_CLASS
 	select POWER_SUPPLY
 	select INPUT_FF_MEMLESS
@@ -719,7 +719,7 @@ config ZEROPLUS_FF
 
 config HID_ZYDACRON
 	tristate "Zydacron remote control support"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Zydacron remote control.
 
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 320a958..9e0c4fbb 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -21,7 +21,6 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 
 #include "hid-ids.h"
 
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index f7f113b..ef89573 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -19,7 +19,6 @@
 #include <linux/input/mt.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 
 #include "hid-ids.h"
 
diff --git a/drivers/hid/hid-speedlink.c b/drivers/hid/hid-speedlink.c
index e94371a..a2f587d 100644
--- a/drivers/hid/hid-speedlink.c
+++ b/drivers/hid/hid-speedlink.c
@@ -16,10 +16,8 @@
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
-#include <linux/usb.h>
 
 #include "hid-ids.h"
-#include "usbhid/usbhid.h"
 
 static const struct hid_device_id speedlink_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_X_TENSIONS, USB_DEVICE_ID_SPEEDLINK_VAD_CEZANNE)},
-- 
1.8.1

