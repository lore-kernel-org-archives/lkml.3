Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936732Ab3DHK1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:27:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935363Ab3DHJvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Ming Lei <ming.lei@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 002/102] Bluetooth: Add support for Dell[QCA 0cf3:0036]
Date: Mon,  8 Apr 2013 10:49:17 +0100
Message-Id: <1365414657-29191-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit d66629c1325399cf080ba8b2fb086c10e5439cdd upstream.

Add support for the AR9462 chip

T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  3 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0cf3 ProdID=0036 Rev= 0.02
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
A:  FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=01
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

Cc: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index b00000e..0f069ec 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -73,6 +73,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x03F0, 0x311D) },
 
 	/* Atheros AR3012 with sflash firmware*/
+	{ USB_DEVICE(0x0CF3, 0x0036) },
 	{ USB_DEVICE(0x0CF3, 0x3004) },
 	{ USB_DEVICE(0x0CF3, 0x311D) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
@@ -100,6 +101,7 @@ MODULE_DEVICE_TABLE(usb, ath3k_table);
 static struct usb_device_id ath3k_blist_tbl[] = {
 
 	/* Atheros AR3012 with sflash firmware*/
+	{ USB_DEVICE(0x0CF3, 0x0036), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311D), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 37f5ba6..984cf1e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -139,6 +139,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros 3012 with sflash firmware */
+	{ USB_DEVICE(0x0cf3, 0x0036), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311d), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
-- 
1.8.1.2

