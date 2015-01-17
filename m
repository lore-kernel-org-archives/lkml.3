Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbbAQVRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 16:17:03 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:33467 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbbAQVRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 16:17:00 -0500
From: Dmitry Tunin <hanipouspilot@gmail.com>
To: linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dmitry Tunin <hanipouspilot@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] ath3k: Add support of AR3012 bluetooth 13d3:3423 device
Date: Sun, 18 Jan 2015 00:16:51 +0300
Message-Id: <1421529411-25385-1-git-send-email-hanipouspilot@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support of 13d3:3423 device.

BugLink: https://bugs.launchpad.net/bugs/1411193 

T: Bus=01 Lev=02 Prnt=03 Port=00 Cnt=01 Dev#= 5 Spd=12 MxCh= 0
D: Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
P: Vendor=13d3 ProdID=3423 Rev= 0.01
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
A: FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=01
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=81(I) Atr=03(Int.) MxPS= 16 Ivl=1ms
E: Ad=82(I) Atr=02(Bulk) MxPS= 64 Ivl=0ms
E: Ad=02(O) Atr=02(Bulk) MxPS= 64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=83(I) Atr=01(Isoc) MxPS= 0 Ivl=1ms
E: Ad=03(O) Atr=01(Isoc) MxPS= 0 Ivl=1ms
I: If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=83(I) Atr=01(Isoc) MxPS= 9 Ivl=1ms
E: Ad=03(O) Atr=01(Isoc) MxPS= 9 Ivl=1ms
I: If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=83(I) Atr=01(Isoc) MxPS= 17 Ivl=1ms
E: Ad=03(O) Atr=01(Isoc) MxPS= 17 Ivl=1ms
I: If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=83(I) Atr=01(Isoc) MxPS= 25 Ivl=1ms
E: Ad=03(O) Atr=01(Isoc) MxPS= 25 Ivl=1ms
I: If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=83(I) Atr=01(Isoc) MxPS= 33 Ivl=1ms
E: Ad=03(O) Atr=01(Isoc) MxPS= 33 Ivl=1ms
I: If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=83(I) Atr=01(Isoc) MxPS= 49 Ivl=1ms
E: Ad=03(O) Atr=01(Isoc) MxPS= 49 Ivl=1ms

Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 1ee27ac..13a64d0 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -108,6 +108,7 @@ static const struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3393) },
 	{ USB_DEVICE(0x13d3, 0x3402) },
 	{ USB_DEVICE(0x13d3, 0x3408) },
+	{ USB_DEVICE(0x13d3, 0x3423) },
 	{ USB_DEVICE(0x13d3, 0x3432) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
@@ -162,6 +163,7 @@ static const struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3423), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4a6495a..1211c74 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -189,6 +189,7 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3423), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
-- 
1.9.1

