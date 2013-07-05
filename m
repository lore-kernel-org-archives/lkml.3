Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab3GEVeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:34:09 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51934 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3GEVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:34:07 -0400
Message-ID: <51D73BCD.1030401@free-electrons.com>
Date: Fri, 05 Jul 2013 23:34:05 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Why no USB id list in the kernel sources?
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm wondering why there is no include/linux/usb_ids.h (or
include/linux/usb/ids.h) file in the same way there is a
include/linux/pci_ids.h for PCI.

I don't expect all product ids to be listed (the
http://www.linux-usb.org/usb.ids list is pretty big), but if we could
have at least vendor ids, it would make device tables cleaner and easier
to read, as we have in most PCI drivers. Here would be an example:

diff --git a/drivers/media/usb/gspca/pac207.c
b/drivers/media/usb/gspca/pac207.c
index 83519be..ce8c975 100644
--- a/drivers/media/usb/gspca/pac207.c
+++ b/drivers/media/usb/gspca/pac207.c
@@ -449,19 +449,19 @@ static const struct sd_desc sd_desc = {
 
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
-       {USB_DEVICE(0x041e, 0x4028)},
-       {USB_DEVICE(0x093a, 0x2460)},
-       {USB_DEVICE(0x093a, 0x2461)},
-       {USB_DEVICE(0x093a, 0x2463)},
-       {USB_DEVICE(0x093a, 0x2464)},
-       {USB_DEVICE(0x093a, 0x2468)},
-       {USB_DEVICE(0x093a, 0x2470)},
-       {USB_DEVICE(0x093a, 0x2471)},
-       {USB_DEVICE(0x093a, 0x2472)},
-       {USB_DEVICE(0x093a, 0x2474)},
-       {USB_DEVICE(0x093a, 0x2476)},
-       {USB_DEVICE(0x145f, 0x013a)},
-       {USB_DEVICE(0x2001, 0xf115)},
+       {USB_DEVICE(USB_VENDOR_ID_CREATIVE, 0x4028)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2460)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2461)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2463)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2464)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2468)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2470)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2471)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2472)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2474)},
+       {USB_DEVICE(USB_VENDOR_ID_PIXART, 0x2476)},
+       {USB_DEVICE(USB_VENDOR_ID_TRUST, 0x013a)},
+       {USB_DEVICE(USB_VENDOR_ID_DLINK, 0xf115)},
        {}
 };
 MODULE_DEVICE_TABLE(usb, device_table);

Does this happen because nobody had the time to create and maintain such
a usb_ids.h file, or would there be any other reasons?

I'm asking because I don't like raw values in situations when a symbolic
name would be more self-explanatory ;)

Thanks,

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

