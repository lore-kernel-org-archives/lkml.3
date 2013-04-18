Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967258Ab3DRJb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:31:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab3DRJRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Schaal <farbing@web.de>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 26/72] Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.
Date: Thu, 18 Apr 2013 10:16:11 +0100
Message-Id: <1366276617-3553-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Schaal <farbing@web.de>

commit 2c262b2a5235b7f5b18d4d58394511f76371d7cb upstream.

T:  Bus=02 Lev=02 Prnt=02 Port=06 Cnt=01 Dev#=  4 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=04ca ProdID=3006 Rev= 0.02
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Daniel Schaal <farbing@web.de>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 46e42fc..67e36f9 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -79,6 +79,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x0CF3, 0x817a) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x04CA, 0x3005) },
+	{ USB_DEVICE(0x04CA, 0x3006) },
 	{ USB_DEVICE(0x13d3, 0x3362) },
 	{ USB_DEVICE(0x0CF3, 0xE004) },
 	{ USB_DEVICE(0x0930, 0x0219) },
@@ -109,6 +110,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x0CF3, 0x817a), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 07f250b..f6e6f7f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -145,6 +145,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0cf3, 0x817a), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
-- 
1.8.1.2

