Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3FGGqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:46:42 -0400
Received: from smtpdg226.aruba.it ([62.149.158.226]:57703 "EHLO
	smtpdg8.aruba.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023Ab3FGGql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:46:41 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 02:46:41 EDT
Message-ID: <51B18035.3060607@novetica.org>
Date: Fri, 07 Jun 2013 08:39:49 +0200
From: Marco Minetti <marco.minetti@novetica.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add bth Asus S400A device support for Atheros AR3012
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've been applying the following patchs seamlessly into kernel 3.9 and 
3.10 for enabling bluetooth support on Asus S400CA notebook. No 
regressions detected so far.

Could it be directly pushed into official branchs?

Thanks,

Marco Minetti

-----------------------------------------------------------------------------
Kernel 3.10

Signed-off-by: Marco Minetti <marco.minetti@novetica.org>
---
diff -rupN a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
--- a/drivers/bluetooth/ath3k.c    2013-05-08 05:58:03.000000000 +0200
+++ b/drivers/bluetooth/ath3k.c    2013-05-11 08:41:05.727487838 +0200
@@ -90,6 +90,7 @@ static struct usb_device_id ath3k_table[
      { USB_DEVICE(0x13d3, 0x3393) },
      { USB_DEVICE(0x0489, 0xe04e) },
      { USB_DEVICE(0x0489, 0xe056) },
+    { USB_DEVICE(0x13d3, 0x3402) },
     { USB_DEVICE(0x0489, 0xe04d) },

      /* Atheros AR5BBU12 with sflash firmware */
@@ -126,6 +127,7 @@ static struct usb_device_id ath3k_blist_
      { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+    { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
     { USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },

      /* Atheros AR5BBU22 with sflash firmware */
diff -rupN a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
--- a/drivers/bluetooth/btusb.c    2013-05-08 05:58:03.000000000 +0200
+++ b/drivers/bluetooth/btusb.c    2013-05-11 08:39:57.667486015 +0200
@@ -148,6 +148,7 @@ static struct usb_device_id blacklist_ta
      { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+    { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },

      /* Atheros AR5BBU12 with sflash firmware */
---


--------------------------------------------------------------------------------------
Kernel 3.9

Signed-off-by: Marco Minetti <marco.minetti@novetica.org>
---
diff -rupN a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
--- a/drivers/bluetooth/ath3k.c    2013-05-08 05:58:03.000000000 +0200
+++ b/drivers/bluetooth/ath3k.c    2013-05-11 08:41:05.727487838 +0200
@@ -90,6 +90,7 @@ static struct usb_device_id ath3k_table[
      { USB_DEVICE(0x13d3, 0x3393) },
      { USB_DEVICE(0x0489, 0xe04e) },
      { USB_DEVICE(0x0489, 0xe056) },
+    { USB_DEVICE(0x13d3, 0x3402) },

      /* Atheros AR5BBU12 with sflash firmware */
      { USB_DEVICE(0x0489, 0xE02C) },
@@ -126,6 +127,7 @@ static struct usb_device_id ath3k_blist_
      { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+    { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },

      /* Atheros AR5BBU22 with sflash firmware */
      { USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
diff -rupN a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
--- a/drivers/bluetooth/btusb.c    2013-05-08 05:58:03.000000000 +0200
+++ b/drivers/bluetooth/btusb.c    2013-05-11 08:39:57.667486015 +0200
@@ -148,6 +148,7 @@ static struct usb_device_id blacklist_ta
      { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+    { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },

      /* Atheros AR5BBU12 with sflash firmware */
      { USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
---


