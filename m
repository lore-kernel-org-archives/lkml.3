Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967641Ab3HIB7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967461Ab3HIB7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sujith Manoharan <sujith@msujith.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 048/102] Bluetooth: ath3k: Add support for ID 0x13d3/0x3402
Date: Thu,  8 Aug 2013 18:57:24 -0700
Message-Id: <20130809015021.359990685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <sujith@msujith.org>

commit 5b77a1f3d7b7360dc2b7c6d2188d39b9f8432907 upstream.

T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  5 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3402 Rev= 0.02
S:  Manufacturer=Atheros Communications
S:  Product=Bluetooth USB Host Controller
S:  SerialNumber=Alaska Day 2006
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=59701

Signed-off-by: Sujith Manoharan <sujith@msujith.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/ath3k.c |    2 ++
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -92,6 +92,7 @@ static struct usb_device_id ath3k_table[
 	{ USB_DEVICE(0x0489, 0xe056) },
 	{ USB_DEVICE(0x0489, 0xe04d) },
 	{ USB_DEVICE(0x04c5, 0x1330) },
+	{ USB_DEVICE(0x13d3, 0x3402) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -130,6 +131,7 @@ static struct usb_device_id ath3k_blist_
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -152,6 +152,7 @@ static struct usb_device_id blacklist_ta
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },


