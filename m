Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbbAUNIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:08:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbbAUNIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:08:01 -0500
From: Michal Marek <mmarek@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hid: Use Kbuild idiom in Makefiles
Date: Wed, 21 Jan 2015 14:07:10 +0100
Message-Id: <1421845630-25431-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use <driver>-$(CONFIG_FOO) syntax to build multipart objects with
optional parts, since all the config options are bool. Also, delete the
obvious comments in the usbhid Makefile.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/hid/Makefile        | 49 +++++++++++----------------------------------
 drivers/hid/usbhid/Makefile | 12 ++---------
 2 files changed, 14 insertions(+), 47 deletions(-)

diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index debd15b..11a3708 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -2,10 +2,7 @@
 # Makefile for the HID driver
 #
 hid-y			:= hid-core.o hid-input.o
-
-ifdef CONFIG_DEBUG_FS
-	hid-objs		+= hid-debug.o
-endif
+hid-$(CONFIG_DEBUG_FS)		+= hid-debug.o
 
 obj-$(CONFIG_HID)		+= hid.o
 obj-$(CONFIG_UHID)		+= uhid.o
@@ -15,23 +12,13 @@ obj-$(CONFIG_HID_GENERIC)	+= hid-generic.o
 hid-$(CONFIG_HIDRAW)		+= hidraw.o
 
 hid-logitech-y		:= hid-lg.o
-ifdef CONFIG_LOGITECH_FF
-	hid-logitech-y	+= hid-lgff.o
-endif
-ifdef CONFIG_LOGIRUMBLEPAD2_FF
-	hid-logitech-y	+= hid-lg2ff.o
-endif
-ifdef CONFIG_LOGIG940_FF
-	hid-logitech-y	+= hid-lg3ff.o
-endif
-ifdef CONFIG_LOGIWHEELS_FF
-	hid-logitech-y	+= hid-lg4ff.o
-endif
+hid-logitech-$(CONFIG_LOGITECH_FF)	+= hid-lgff.o
+hid-logitech-$(CONFIG_LOGIRUMBLEPAD2_FF)	+= hid-lg2ff.o
+hid-logitech-$(CONFIG_LOGIG940_FF)	+= hid-lg3ff.o
+hid-logitech-$(CONFIG_LOGIWHEELS_FF)	+= hid-lg4ff.o
 
 hid-wiimote-y		:= hid-wiimote-core.o hid-wiimote-modules.o
-ifdef CONFIG_DEBUG_FS
-	hid-wiimote-y	+= hid-wiimote-debug.o
-endif
+hid-wiimote-$(CONFIG_DEBUG_FS)	+= hid-wiimote-debug.o
 
 obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
 obj-$(CONFIG_HID_ACRUX)		+= hid-axff.o
@@ -76,24 +63,12 @@ obj-$(CONFIG_HID_PENMOUNT)	+= hid-penmount.o
 obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
 obj-$(CONFIG_HID_PICOLCD)	+= hid-picolcd.o
 hid-picolcd-y			+= hid-picolcd_core.o
-ifdef CONFIG_HID_PICOLCD_FB
-hid-picolcd-y			+= hid-picolcd_fb.o
-endif
-ifdef CONFIG_HID_PICOLCD_BACKLIGHT
-hid-picolcd-y			+= hid-picolcd_backlight.o
-endif
-ifdef CONFIG_HID_PICOLCD_LCD
-hid-picolcd-y			+= hid-picolcd_lcd.o
-endif
-ifdef CONFIG_HID_PICOLCD_LEDS
-hid-picolcd-y			+= hid-picolcd_leds.o
-endif
-ifdef CONFIG_HID_PICOLCD_CIR
-hid-picolcd-y			+= hid-picolcd_cir.o
-endif
-ifdef CONFIG_DEBUG_FS
-hid-picolcd-y			+= hid-picolcd_debugfs.o
-endif
+hid-picolcd-$(CONFIG_HID_PICOLCD_FB)	+= hid-picolcd_fb.o
+hid-picolcd-$(CONFIG_HID_PICOLCD_BACKLIGHT)	+= hid-picolcd_backlight.o
+hid-picolcd-$(CONFIG_HID_PICOLCD_LCD)	+= hid-picolcd_lcd.o
+hid-picolcd-$(CONFIG_HID_PICOLCD_LEDS)	+= hid-picolcd_leds.o
+hid-picolcd-$(CONFIG_HID_PICOLCD_CIR)	+= hid-picolcd_cir.o
+hid-picolcd-$(CONFIG_DEBUG_FS)		+= hid-picolcd_debugfs.o
 
 obj-$(CONFIG_HID_PLANTRONICS)	+= hid-plantronics.o
 obj-$(CONFIG_HID_PRIMAX)	+= hid-primax.o
diff --git a/drivers/hid/usbhid/Makefile b/drivers/hid/usbhid/Makefile
index db3cf31..890f291 100644
--- a/drivers/hid/usbhid/Makefile
+++ b/drivers/hid/usbhid/Makefile
@@ -2,17 +2,9 @@
 # Makefile for the USB input drivers
 #
 
-# Multipart objects.
 usbhid-y	:= hid-core.o hid-quirks.o
-
-# Optional parts of multipart objects.
-
-ifeq ($(CONFIG_USB_HIDDEV),y)
-	usbhid-y	+= hiddev.o
-endif
-ifeq ($(CONFIG_HID_PID),y)
-	usbhid-y	+= hid-pidff.o
-endif
+usbhid-$(CONFIG_USB_HIDDEV)	+= hiddev.o
+usbhid-$(CONFIG_HID_PID)	+= hid-pidff.o
 
 obj-$(CONFIG_USB_HID)		+= usbhid.o
 obj-$(CONFIG_USB_KBD)		+= usbkbd.o
-- 
2.1.2

