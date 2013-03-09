Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab3CIQdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 11:33:46 -0500
Received: from fallback6.mail.ru ([94.100.176.134]:35274 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab3CIQdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 11:33:45 -0500
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Phil Dibowitz <phil@ipom.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player
Date: Sat,  9 Mar 2013 20:30:58 +0400
Message-Id: <1362846658-6624-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.10.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device stucks on filesystem writes, unless following quirk is passed:
  echo 04e8:5136:m > /sys/module/usb_storage/parameters/quirks

Add corresponding entry to unusual_devs.h

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

Header at drivers/usb/storage/unusual_devs.h suggests to attach
contents of /proc/bus/usb/devices , but usbfs is long time gone,
and I have no idea if there's a replacement for this "devices" file.

Anyway, here's the output of lsusb -d 04e8:5136 -vv

Bus 001 Device 005: ID 04e8:5136 Samsung Electronics Co., Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x04e8 Samsung Electronics Co., Ltd
  idProduct          0x5136 
  bcdDevice            4.00
  iManufacturer           1 SAMSUNG Electronics.Co.Ltd
  iProduct                2 YP-Z3
  iSerial                 3 C35C39990255BF499553C58703677BFD
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0xffff
  Self Powered
  Remote Wakeup Enabled
  Test Mode
  Debug Mode



diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 72923b5..519e8d2 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -488,6 +488,13 @@ UNUSUAL_DEV(  0x04e8, 0x5122, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 | US_FL_BULK_IGNORE_TAG),
 
+/* Added by Dmitry Artamonow <mad_soft@inbox.ru> */
+UNUSUAL_DEV(  0x04e8, 0x5136, 0x0000, 0x9999,
+		"Samsung",
+		"YP-Z3",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64),
+
 /* Entry and supporting patch by Theodore Kilgore <kilgota@auburn.edu>.
  * Device uses standards-violating 32-byte Bulk Command Block Wrappers and
  * reports itself as "Proprietary SCSI Bulk." Cf. device entry 0x084d:0x0011.
-- 
1.7.5.1.300.gc565c

