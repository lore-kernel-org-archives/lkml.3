Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3GROgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:36:17 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:41168 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3GROgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:36:14 -0400
MIME-Version: 1.0
From: Dan Bolsun <dan.bolsun@gmail.com>
Date: Thu, 18 Jul 2013 17:35:53 +0300
Message-ID: <CAKs5=kS5nSN=-U6S-sBA1G-8ayB0GC2d5ZZeo8qSb_Gv9gKkUw@mail.gmail.com>
Subject: [PATCH] usbserial: append Petatel NP10T device to GSM modems list
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was tested on 3.10.1 kernel.

Same models of Petatel NP10T modems have different device IDs.
Unfortunately they have no additional revision information on a board
which may treat them as different devices. Currently I've seen only
two NP10T devices with various IDs. Possibly Petatel NP10T list will
be appended upon devices with new IDs will appear.

--- linux-3.10.1/drivers/usb/serial/option.c    2013-07-01
01:13:29.000000000 +0300
+++ linux-3.10.1.np10t/drivers/usb/serial/option.c      2013-07-18
16:15:36.902600324 +0300
@@ -446,7 +446,8 @@ static void option_instat_callback(struc

 /* Hyundai Petatel Inc. products */
 #define PETATEL_VENDOR_ID                      0x1ff4
-#define PETATEL_PRODUCT_NP10T                  0x600e
+#define PETATEL_PRODUCT_NP10T_600A             0x600a
+#define PETATEL_PRODUCT_NP10T_600E             0x600e

 /* TP-LINK Incorporated products */
 #define TPLINK_VENDOR_ID                       0x2357
@@ -1333,7 +1334,8 @@ static const struct usb_device_id option
        { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
        { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
        { USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
-       { USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
+       { USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600A) },
+       { USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600E) },
        { USB_DEVICE(TPLINK_VENDOR_ID, TPLINK_PRODUCT_MA180),
          .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
        { USB_DEVICE(CHANGHONG_VENDOR_ID, CHANGHONG_PRODUCT_CH690) },

Signed-off-by: Daniil Bolsun <dan.bolsun@gmail.com>
