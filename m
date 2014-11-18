Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731AbaKRPTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:19:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbaKROJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 023/206] Bluetooth: Add support for Intel bootloader devices
Date: Tue, 18 Nov 2014 15:06:18 +0100
Message-Id: <c7e56b1a35a924e8011700e748cd8fcb7eedc0e1.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 40df783d1ef1989ac454e3dfcda017270b8950e6 upstream.

Intel Bluetooth devices that boot up in bootloader mode can not
be used as generic HCI devices, but their HCI transport is still
valuable and so bring that up as raw-only devices.

T:  Bus=02 Lev=02 Prnt=03 Port=00 Cnt=01 Dev#= 14 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=ff(vend.) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=8087 ProdID=0a5a Rev= 0.00
S:  Manufacturer=Intel(R) Corporation
S:  Product=Intel(R) Wilkins Peak 2x2
S:  SerialNumber=001122334455 WP_A0
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bluetooth/btusb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 07276017b4f9..4e86b93b90f0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -49,6 +49,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_WRONG_SCO_MTU	0x40
 #define BTUSB_ATH3012		0x80
 #define BTUSB_INTEL		0x100
+#define BTUSB_INTEL_BOOT	0x200
 
 static struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -119,6 +120,9 @@ static struct usb_device_id btusb_table[] = {
 	/* IMC Networks - Broadcom based */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x13d3, 0xff, 0x01, 0x01) },
 
+	/* Intel Bluetooth USB Bootloader (RAM module) */
+	{ USB_DEVICE(0x8087, 0x0a5a), .driver_info = BTUSB_INTEL_BOOT },
+
 	{ }	/* Terminating entry */
 };
 
@@ -1451,6 +1455,9 @@ static int btusb_probe(struct usb_interface *intf,
 	if (id->driver_info & BTUSB_INTEL)
 		hdev->setup = btusb_setup_intel;
 
+	if (id->driver_info & BTUSB_INTEL_BOOT)
+		set_bit(HCI_QUIRK_RAW_DEVICE, &hdev->quirks);
+
 	/* Interface numbers are hardcoded in the specification */
 	data->isoc = usb_ifnum_to_if(data->udev, 1);
 
-- 
2.1.3

