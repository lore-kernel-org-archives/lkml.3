Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab3J1EB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 00:01:59 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:53403 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3J1EB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 00:01:57 -0400
Message-ID: <526DE1B2.5010302@gmail.com>
Date: Mon, 28 Oct 2013 00:01:54 -0400
From: Chris Bajumpaa <cbajumpa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for POD HD400 to line6usb driver
Content-Type: multipart/mixed;
 boundary="------------040803000400010900000509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040803000400010900000509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

     This patch adds support for the Line 6 POD HD400 to the line6usb 
driver.


--- 8< Patch starts here ----

diff -ur stock/linux-3.11.6/drivers/staging/line6/driver.c 
line6/linux-3.11.6/drivers/staging/line6/driver.c
--- stock/linux-3.11.6/drivers/staging/line6/driver.c    2013-10-18 
14:24:16.000000000 -0400
+++ line6/linux-3.11.6/drivers/staging/line6/driver.c    2013-10-27 
23:49:03.238659004 -0400
@@ -38,6 +38,7 @@
      {USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_GUITARPORT)},
      {USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_POCKETPOD)},
      {USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD300)},
+    {USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD400)},
      {USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD500)},
      {USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_GX)},
      {USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX1)},
@@ -64,6 +65,7 @@
      { LINE6_BIT_GUITARPORT,    "GuitarPort",    "GuitarPort", 
LINE6_BIT_PCM               },
      { LINE6_BIT_POCKETPOD,     "PocketPOD",     "Pocket POD", 
LINE6_BIT_CONTROL           },
      { LINE6_BIT_PODHD300,      "PODHD300",      "POD HD300", 
LINE6_BIT_CONTROL_PCM_HWMON },
+    { LINE6_BIT_PODHD400,      "PODHD400",      "POD HD400", 
LINE6_BIT_CONTROL_PCM_HWMON },
      { LINE6_BIT_PODHD500,      "PODHD500",      "POD HD500", 
LINE6_BIT_CONTROL_PCM_HWMON },
      { LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX", 
LINE6_BIT_PCM               },
      { LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1", 
LINE6_BIT_PCM               },
@@ -352,6 +354,7 @@
              break;

          case LINE6_DEVID_PODHD300:
+        case LINE6_DEVID_PODHD400:
          case LINE6_DEVID_PODHD500:
              break; /* let userspace handle MIDI */

@@ -693,6 +696,7 @@
      case LINE6_DEVID_PODXT:
      case LINE6_DEVID_PODXTPRO:
      case LINE6_DEVID_PODHD300:
+    case LINE6_DEVID_PODHD400:
          alternate = 5;
          break;

@@ -747,6 +751,7 @@
          break;

      case LINE6_DEVID_PODHD300:
+    case LINE6_DEVID_PODHD400:
          size = sizeof(struct usb_line6_podhd);
          ep_read = 0x84;
          ep_write = 0x03;
@@ -905,6 +910,7 @@
          break;

      case LINE6_DEVID_PODHD300:
+    case LINE6_DEVID_PODHD400:
      case LINE6_DEVID_PODHD500:
          ret = line6_podhd_init(interface,
                         (struct usb_line6_podhd *)line6);
@@ -1032,6 +1038,7 @@
              break;

          case LINE6_DEVID_PODHD300:
+        case LINE6_DEVID_PODHD400:
          case LINE6_DEVID_PODHD500:
              line6_podhd_disconnect(interface);
              break;
diff -ur stock/linux-3.11.6/drivers/staging/line6/pcm.c 
line6/linux-3.11.6/drivers/staging/line6/pcm.c
--- stock/linux-3.11.6/drivers/staging/line6/pcm.c    2013-10-18 
14:24:16.000000000 -0400
+++ line6/linux-3.11.6/drivers/staging/line6/pcm.c    2013-10-27 
23:49:03.238659004 -0400
@@ -439,6 +439,7 @@
      case LINE6_DEVID_PODXTLIVE:
      case LINE6_DEVID_PODXTPRO:
      case LINE6_DEVID_PODHD300:
+    case LINE6_DEVID_PODHD400:
          ep_read = 0x82;
          ep_write = 0x01;
          break;
diff -ur stock/linux-3.11.6/drivers/staging/line6/usbdefs.h 
line6/linux-3.11.6/drivers/staging/line6/usbdefs.h
--- stock/linux-3.11.6/drivers/staging/line6/usbdefs.h    2013-10-18 
14:24:16.000000000 -0400
+++ line6/linux-3.11.6/drivers/staging/line6/usbdefs.h    2013-10-27 
23:49:03.238659004 -0400
@@ -25,6 +25,7 @@
  #define LINE6_DEVID_GUITARPORT    0x4750
  #define LINE6_DEVID_POCKETPOD     0x5051
  #define LINE6_DEVID_PODHD300      0x5057
+#define LINE6_DEVID_PODHD400      0x5058
  #define LINE6_DEVID_PODHD500      0x414D
  #define LINE6_DEVID_PODSTUDIO_GX  0x4153
  #define LINE6_DEVID_PODSTUDIO_UX1 0x4150
@@ -48,6 +49,7 @@
      LINE6_INDEX_GUITARPORT,
      LINE6_INDEX_POCKETPOD,
      LINE6_INDEX_PODHD300,
+    LINE6_INDEX_PODHD400,
      LINE6_INDEX_PODHD500,
      LINE6_INDEX_PODSTUDIO_GX,
      LINE6_INDEX_PODSTUDIO_UX1,
@@ -68,6 +70,7 @@
      LINE6_BIT(GUITARPORT),
      LINE6_BIT(POCKETPOD),
      LINE6_BIT(PODHD300),
+    LINE6_BIT(PODHD400),
      LINE6_BIT(PODHD500),
      LINE6_BIT(PODSTUDIO_GX),
      LINE6_BIT(PODSTUDIO_UX1),
@@ -88,7 +91,9 @@
      LINE6_BITS_PODXTALL = LINE6_BIT_PODXT | LINE6_BIT_PODXTLIVE |
                    LINE6_BIT_PODXTPRO,
      LINE6_BITS_PODX3ALL = LINE6_BIT_PODX3 | LINE6_BIT_PODX3LIVE,
-    LINE6_BITS_PODHDALL = LINE6_BIT_PODHD300 | LINE6_BIT_PODHD500,
+    LINE6_BITS_PODHDALL =     LINE6_BIT_PODHD300 |
+                LINE6_BIT_PODHD400 |
+                LINE6_BIT_PODHD500,
      LINE6_BITS_BASSPODXTALL    = LINE6_BIT_BASSPODXT |
                    LINE6_BIT_BASSPODXTLIVE |
                    LINE6_BIT_BASSPODXTPRO




--------------040803000400010900000509
Content-Type: text/x-patch;
 name="line6-hd400-3.11.6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="line6-hd400-3.11.6.patch"

diff -ur stock/linux-3.11.6/drivers/staging/line6/driver.c line6/linux-3.11.6/drivers/staging/line6/driver.c
--- stock/linux-3.11.6/drivers/staging/line6/driver.c	2013-10-18 14:24:16.000000000 -0400
+++ line6/linux-3.11.6/drivers/staging/line6/driver.c	2013-10-27 23:49:03.238659004 -0400
@@ -38,6 +38,7 @@
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_GUITARPORT)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_POCKETPOD)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD300)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD400)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD500)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_GX)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX1)},
@@ -64,6 +65,7 @@
 	{ LINE6_BIT_GUITARPORT,    "GuitarPort",    "GuitarPort",       LINE6_BIT_PCM               },
 	{ LINE6_BIT_POCKETPOD,     "PocketPOD",     "Pocket POD",       LINE6_BIT_CONTROL           },
 	{ LINE6_BIT_PODHD300,      "PODHD300",      "POD HD300",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODHD400,      "PODHD400",      "POD HD400",        LINE6_BIT_CONTROL_PCM_HWMON },
 	{ LINE6_BIT_PODHD500,      "PODHD500",      "POD HD500",        LINE6_BIT_CONTROL_PCM_HWMON },
 	{ LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    LINE6_BIT_PCM               },
 	{ LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   LINE6_BIT_PCM               },
@@ -352,6 +354,7 @@
 			break;
 
 		case LINE6_DEVID_PODHD300:
+		case LINE6_DEVID_PODHD400:
 		case LINE6_DEVID_PODHD500:
 			break; /* let userspace handle MIDI */
 
@@ -693,6 +696,7 @@
 	case LINE6_DEVID_PODXT:
 	case LINE6_DEVID_PODXTPRO:
 	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
 		alternate = 5;
 		break;
 
@@ -747,6 +751,7 @@
 		break;
 
 	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
 		size = sizeof(struct usb_line6_podhd);
 		ep_read = 0x84;
 		ep_write = 0x03;
@@ -905,6 +910,7 @@
 		break;
 
 	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
 	case LINE6_DEVID_PODHD500:
 		ret = line6_podhd_init(interface,
 				       (struct usb_line6_podhd *)line6);
@@ -1032,6 +1038,7 @@
 			break;
 
 		case LINE6_DEVID_PODHD300:
+		case LINE6_DEVID_PODHD400:
 		case LINE6_DEVID_PODHD500:
 			line6_podhd_disconnect(interface);
 			break;
diff -ur stock/linux-3.11.6/drivers/staging/line6/pcm.c line6/linux-3.11.6/drivers/staging/line6/pcm.c
--- stock/linux-3.11.6/drivers/staging/line6/pcm.c	2013-10-18 14:24:16.000000000 -0400
+++ line6/linux-3.11.6/drivers/staging/line6/pcm.c	2013-10-27 23:49:03.238659004 -0400
@@ -439,6 +439,7 @@
 	case LINE6_DEVID_PODXTLIVE:
 	case LINE6_DEVID_PODXTPRO:
 	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
 		ep_read = 0x82;
 		ep_write = 0x01;
 		break;
diff -ur stock/linux-3.11.6/drivers/staging/line6/usbdefs.h line6/linux-3.11.6/drivers/staging/line6/usbdefs.h
--- stock/linux-3.11.6/drivers/staging/line6/usbdefs.h	2013-10-18 14:24:16.000000000 -0400
+++ line6/linux-3.11.6/drivers/staging/line6/usbdefs.h	2013-10-27 23:49:03.238659004 -0400
@@ -25,6 +25,7 @@
 #define LINE6_DEVID_GUITARPORT    0x4750
 #define LINE6_DEVID_POCKETPOD     0x5051
 #define LINE6_DEVID_PODHD300      0x5057
+#define LINE6_DEVID_PODHD400      0x5058
 #define LINE6_DEVID_PODHD500      0x414D
 #define LINE6_DEVID_PODSTUDIO_GX  0x4153
 #define LINE6_DEVID_PODSTUDIO_UX1 0x4150
@@ -48,6 +49,7 @@
 	LINE6_INDEX_GUITARPORT,
 	LINE6_INDEX_POCKETPOD,
 	LINE6_INDEX_PODHD300,
+	LINE6_INDEX_PODHD400,
 	LINE6_INDEX_PODHD500,
 	LINE6_INDEX_PODSTUDIO_GX,
 	LINE6_INDEX_PODSTUDIO_UX1,
@@ -68,6 +70,7 @@
 	LINE6_BIT(GUITARPORT),
 	LINE6_BIT(POCKETPOD),
 	LINE6_BIT(PODHD300),
+	LINE6_BIT(PODHD400),
 	LINE6_BIT(PODHD500),
 	LINE6_BIT(PODSTUDIO_GX),
 	LINE6_BIT(PODSTUDIO_UX1),
@@ -88,7 +91,9 @@
 	LINE6_BITS_PODXTALL = LINE6_BIT_PODXT | LINE6_BIT_PODXTLIVE |
 			      LINE6_BIT_PODXTPRO,
 	LINE6_BITS_PODX3ALL = LINE6_BIT_PODX3 | LINE6_BIT_PODX3LIVE,
-	LINE6_BITS_PODHDALL = LINE6_BIT_PODHD300 | LINE6_BIT_PODHD500,
+	LINE6_BITS_PODHDALL = 	LINE6_BIT_PODHD300 | 
+				LINE6_BIT_PODHD400 |
+				LINE6_BIT_PODHD500,
 	LINE6_BITS_BASSPODXTALL	= LINE6_BIT_BASSPODXT |
 				  LINE6_BIT_BASSPODXTLIVE |
 				  LINE6_BIT_BASSPODXTPRO

--------------040803000400010900000509--
