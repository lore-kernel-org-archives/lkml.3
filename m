Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3LUWvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 17:51:31 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:61849 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3LUWva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 17:51:30 -0500
Message-ID: <52B61B6C.4000407@gmail.com>
Date: Sat, 21 Dec 2013 17:51:24 -0500
From: Chris Bajumpaa <cbajumpa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for POD HD400 to line6usb driver
References: <526DE1B2.5010302@gmail.com> <20131209012213.GA25305@kroah.com> <52B54525.30002@gmail.com> <20131221174453.GB27957@kroah.com>
In-Reply-To: <20131221174453.GB27957@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------060101010503010601080406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060101010503010601080406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This one applies clean to a current tree and has a Signed-off-by: line.
And is CC'd to the right places. And doesn't have the tabs eaten...

Sorry about that.

This patch adds support for the Line 6 POD HD400 to the line6usb driver.

Signed-off-by: Chris Bajumpaa <cbajumpa@gmail.com>

---

diff -uprN linux/drivers/staging/line6/driver.c line6/drivers/staging/line6/driver.c
--- linux/drivers/staging/line6/driver.c	2013-12-21 01:42:31.115328441 -0500
+++ line6/drivers/staging/line6/driver.c	2013-12-21 02:05:16.839285680 -0500
@@ -38,6 +38,7 @@ static const struct usb_device_id line6_
  	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_GUITARPORT)},
  	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_POCKETPOD)},
  	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD300)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD400)},
  	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD500)},
  	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_GX)},
  	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX1)},
@@ -64,6 +65,7 @@ static struct line6_properties line6_pro
  	{ LINE6_BIT_GUITARPORT,    "GuitarPort",    "GuitarPort",       LINE6_BIT_PCM               },
  	{ LINE6_BIT_POCKETPOD,     "PocketPOD",     "Pocket POD",       LINE6_BIT_CONTROL           },
  	{ LINE6_BIT_PODHD300,      "PODHD300",      "POD HD300",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODHD400,      "PODHD400",      "POD HD400",        LINE6_BIT_CONTROL_PCM_HWMON },
  	{ LINE6_BIT_PODHD500,      "PODHD500",      "POD HD500",        LINE6_BIT_CONTROL_PCM_HWMON },
  	{ LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    LINE6_BIT_PCM               },
  	{ LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   LINE6_BIT_PCM               },
@@ -352,6 +354,7 @@ static void line6_data_received(struct u
  			break;
  
  		case LINE6_DEVID_PODHD300:
+		case LINE6_DEVID_PODHD400:
  		case LINE6_DEVID_PODHD500:
  			break; /* let userspace handle MIDI */
  
@@ -693,6 +696,7 @@ static int line6_probe(struct usb_interf
  	case LINE6_DEVID_PODXT:
  	case LINE6_DEVID_PODXTPRO:
  	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
  		alternate = 5;
  		break;
  
@@ -747,6 +751,7 @@ static int line6_probe(struct usb_interf
  		break;
  
  	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
  		size = sizeof(struct usb_line6_podhd);
  		ep_read = 0x84;
  		ep_write = 0x03;
@@ -905,6 +910,7 @@ static int line6_probe(struct usb_interf
  		break;
  
  	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
  	case LINE6_DEVID_PODHD500:
  		ret = line6_podhd_init(interface,
  				       (struct usb_line6_podhd *)line6);
@@ -1032,6 +1038,7 @@ static void line6_disconnect(struct usb_
  			break;
  
  		case LINE6_DEVID_PODHD300:
+		case LINE6_DEVID_PODHD400:
  		case LINE6_DEVID_PODHD500:
  			line6_podhd_disconnect(interface);
  			break;
diff -uprN linux/drivers/staging/line6/pcm.c line6/drivers/staging/line6/pcm.c
--- linux/drivers/staging/line6/pcm.c	2013-12-21 01:42:31.115328441 -0500
+++ line6/drivers/staging/line6/pcm.c	2013-12-21 02:05:16.839285680 -0500
@@ -439,6 +439,7 @@ int line6_init_pcm(struct usb_line6 *lin
  	case LINE6_DEVID_PODXTLIVE:
  	case LINE6_DEVID_PODXTPRO:
  	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
  		ep_read = 0x82;
  		ep_write = 0x01;
  		break;
diff -uprN linux/drivers/staging/line6/usbdefs.h line6/drivers/staging/line6/usbdefs.h
--- linux/drivers/staging/line6/usbdefs.h	2013-12-21 01:42:31.115328441 -0500
+++ line6/drivers/staging/line6/usbdefs.h	2013-12-21 02:05:16.843285680 -0500
@@ -25,6 +25,7 @@
  #define LINE6_DEVID_GUITARPORT    0x4750
  #define LINE6_DEVID_POCKETPOD     0x5051
  #define LINE6_DEVID_PODHD300      0x5057
+#define LINE6_DEVID_PODHD400      0x5058
  #define LINE6_DEVID_PODHD500      0x414D
  #define LINE6_DEVID_PODSTUDIO_GX  0x4153
  #define LINE6_DEVID_PODSTUDIO_UX1 0x4150
@@ -48,6 +49,7 @@ enum {
  	LINE6_INDEX_GUITARPORT,
  	LINE6_INDEX_POCKETPOD,
  	LINE6_INDEX_PODHD300,
+	LINE6_INDEX_PODHD400,
  	LINE6_INDEX_PODHD500,
  	LINE6_INDEX_PODSTUDIO_GX,
  	LINE6_INDEX_PODSTUDIO_UX1,
@@ -68,6 +70,7 @@ enum {
  	LINE6_BIT(GUITARPORT),
  	LINE6_BIT(POCKETPOD),
  	LINE6_BIT(PODHD300),
+	LINE6_BIT(PODHD400),
  	LINE6_BIT(PODHD500),
  	LINE6_BIT(PODSTUDIO_GX),
  	LINE6_BIT(PODSTUDIO_UX1),
@@ -88,7 +91,9 @@ enum {
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



--------------060101010503010601080406
Content-Type: text/x-patch;
 name="line6-hd400-clean-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="line6-hd400-clean-2.patch"

diff -uprN linux/drivers/staging/line6/driver.c line6/drivers/staging/line6/driver.c
--- linux/drivers/staging/line6/driver.c	2013-12-21 01:42:31.115328441 -0500
+++ line6/drivers/staging/line6/driver.c	2013-12-21 02:05:16.839285680 -0500
@@ -38,6 +38,7 @@ static const struct usb_device_id line6_
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_GUITARPORT)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_POCKETPOD)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD300)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD400)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD500)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_GX)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX1)},
@@ -64,6 +65,7 @@ static struct line6_properties line6_pro
 	{ LINE6_BIT_GUITARPORT,    "GuitarPort",    "GuitarPort",       LINE6_BIT_PCM               },
 	{ LINE6_BIT_POCKETPOD,     "PocketPOD",     "Pocket POD",       LINE6_BIT_CONTROL           },
 	{ LINE6_BIT_PODHD300,      "PODHD300",      "POD HD300",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODHD400,      "PODHD400",      "POD HD400",        LINE6_BIT_CONTROL_PCM_HWMON },
 	{ LINE6_BIT_PODHD500,      "PODHD500",      "POD HD500",        LINE6_BIT_CONTROL_PCM_HWMON },
 	{ LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    LINE6_BIT_PCM               },
 	{ LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   LINE6_BIT_PCM               },
@@ -352,6 +354,7 @@ static void line6_data_received(struct u
 			break;
 
 		case LINE6_DEVID_PODHD300:
+		case LINE6_DEVID_PODHD400:
 		case LINE6_DEVID_PODHD500:
 			break; /* let userspace handle MIDI */
 
@@ -693,6 +696,7 @@ static int line6_probe(struct usb_interf
 	case LINE6_DEVID_PODXT:
 	case LINE6_DEVID_PODXTPRO:
 	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
 		alternate = 5;
 		break;
 
@@ -747,6 +751,7 @@ static int line6_probe(struct usb_interf
 		break;
 
 	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
 		size = sizeof(struct usb_line6_podhd);
 		ep_read = 0x84;
 		ep_write = 0x03;
@@ -905,6 +910,7 @@ static int line6_probe(struct usb_interf
 		break;
 
 	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
 	case LINE6_DEVID_PODHD500:
 		ret = line6_podhd_init(interface,
 				       (struct usb_line6_podhd *)line6);
@@ -1032,6 +1038,7 @@ static void line6_disconnect(struct usb_
 			break;
 
 		case LINE6_DEVID_PODHD300:
+		case LINE6_DEVID_PODHD400:
 		case LINE6_DEVID_PODHD500:
 			line6_podhd_disconnect(interface);
 			break;
diff -uprN linux/drivers/staging/line6/pcm.c line6/drivers/staging/line6/pcm.c
--- linux/drivers/staging/line6/pcm.c	2013-12-21 01:42:31.115328441 -0500
+++ line6/drivers/staging/line6/pcm.c	2013-12-21 02:05:16.839285680 -0500
@@ -439,6 +439,7 @@ int line6_init_pcm(struct usb_line6 *lin
 	case LINE6_DEVID_PODXTLIVE:
 	case LINE6_DEVID_PODXTPRO:
 	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD400:
 		ep_read = 0x82;
 		ep_write = 0x01;
 		break;
diff -uprN linux/drivers/staging/line6/usbdefs.h line6/drivers/staging/line6/usbdefs.h
--- linux/drivers/staging/line6/usbdefs.h	2013-12-21 01:42:31.115328441 -0500
+++ line6/drivers/staging/line6/usbdefs.h	2013-12-21 02:05:16.843285680 -0500
@@ -25,6 +25,7 @@
 #define LINE6_DEVID_GUITARPORT    0x4750
 #define LINE6_DEVID_POCKETPOD     0x5051
 #define LINE6_DEVID_PODHD300      0x5057
+#define LINE6_DEVID_PODHD400      0x5058
 #define LINE6_DEVID_PODHD500      0x414D
 #define LINE6_DEVID_PODSTUDIO_GX  0x4153
 #define LINE6_DEVID_PODSTUDIO_UX1 0x4150
@@ -48,6 +49,7 @@ enum {
 	LINE6_INDEX_GUITARPORT,
 	LINE6_INDEX_POCKETPOD,
 	LINE6_INDEX_PODHD300,
+	LINE6_INDEX_PODHD400,
 	LINE6_INDEX_PODHD500,
 	LINE6_INDEX_PODSTUDIO_GX,
 	LINE6_INDEX_PODSTUDIO_UX1,
@@ -68,6 +70,7 @@ enum {
 	LINE6_BIT(GUITARPORT),
 	LINE6_BIT(POCKETPOD),
 	LINE6_BIT(PODHD300),
+	LINE6_BIT(PODHD400),
 	LINE6_BIT(PODHD500),
 	LINE6_BIT(PODSTUDIO_GX),
 	LINE6_BIT(PODSTUDIO_UX1),
@@ -88,7 +91,9 @@ enum {
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

--------------060101010503010601080406--
