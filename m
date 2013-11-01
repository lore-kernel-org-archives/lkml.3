Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab3KAN32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:29:28 -0400
Received: from forward14.mail.yandex.net ([95.108.130.92]:33370 "EHLO
	forward14.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KAN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:29:27 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2013 09:29:27 EDT
Authentication-Results: smtp13.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <5273AC0E.3010005@yandex.ru>
Date: Fri, 01 Nov 2013 17:26:38 +0400
From: =?UTF-8?B?0JDQu9C10LrRgdC10Lkg0JrRgNCw0LzQsNGA0LXQvdC60L4=?= 
	<alexeyk13@yandex.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131008 Thunderbird/17.0.9
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: FTDI custom VID/PID patch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg.

It's my first patch, sorry if something wrong.

Custom VID/PID for Z3X Box device, popular tool for cellphone flashing.

diff -uprN -X linux-3.11.6-vanilla/Documentation/dontdiff
linux-3.11.6-vanilla/drivers/usb/serial/ftdi_sio.c
linux-3.11.6-devel/drivers/usb/serial/ftdi_sio.c
--- linux-3.11.6-vanilla/drivers/usb/serial/ftdi_sio.c  2013-10-18
22:24:16.000000000 +0400
+++ linux-3.11.6-devel/drivers/usb/serial/ftdi_sio.c    2013-11-01
16:53:25.518999202 +0400
@@ -906,6 +906,7 @@ static struct usb_device_id id_table_com
        { USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
        /* Crucible Devices */
        { USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
        { },                                    /* Optional parameter
entry */
        { }                                     /* Terminating entry */
 };
diff -uprN -X linux-3.11.6-vanilla/Documentation/dontdiff
linux-3.11.6-vanilla/drivers/usb/serial/ftdi_sio_ids.h
linux-3.11.6-devel/drivers/usb/serial/ftdi_sio_ids.h
--- linux-3.11.6-vanilla/drivers/usb/serial/ftdi_sio_ids.h     
2013-10-18 22:24:16.000000000 +0400
+++ linux-3.11.6-devel/drivers/usb/serial/ftdi_sio_ids.h       
2013-11-01 16:52:37.288999208 +0400
@@ -1307,3 +1307,9 @@
  * Manufacturer: Crucible Technologies
  */
 #define FTDI_CT_COMET_PID      0x8e08
+
+/*
+ * Product: Z3X Box
+ * Manufacturer: Smart GSM Team
+ */
+#define FTDI_Z3X_PID    0x0011

Signed-off-by: Alexey E. Kramarenko <alexeyk13@yandex.ru>

