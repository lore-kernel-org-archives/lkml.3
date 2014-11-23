Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaKWMPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 07:15:41 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35004 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaKWMPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 07:15:40 -0500
Message-ID: <5471CFE9.9070109@gmail.com>
Date: Sun, 23 Nov 2014 15:15:37 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] ath3k: Add support of MCI 13d3:3408 bt device
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for bluetooth MCI WB335 (AR9565) Wi-Fi+bt module.
This bluetooth module requires loading patch and sysconfig by ath3k driver.

/sys/kernel/debug/usb/devices

T:  Bus=01 Lev=02 Prnt=03 Port=00 Cnt=01 Dev#= 20 Spd=12 MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
P:  Vendor=13d3 ProdID=3408 Rev= 0.02
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

Signed-off-by: Dmitry Tunin<hanipouspilot@gmail.com>

---

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index d85ced2..086240c 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -105,6 +105,7 @@ static const struct usb_device_id ath3k_table[] = {
      { USB_DEVICE(0x13d3, 0x3375) },
      { USB_DEVICE(0x13d3, 0x3393) },
      { USB_DEVICE(0x13d3, 0x3402) },
+    { USB_DEVICE(0x13d3, 0x3408) },
      { USB_DEVICE(0x13d3, 0x3432) },

      /* Atheros AR5BBU12 with sflash firmware */
@@ -156,6 +157,7 @@ static const struct usb_device_id ath3k_blist_tbl[] = {
      { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+    { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },

      /* Atheros AR5BBU22 with sflash firmware */
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index edfc17b..091c813 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -182,6 +182,7 @@ static const struct usb_device_id blacklist_table[] = {
      { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+    { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },

      /* Atheros AR5BBU12 with sflash firmware */

--

Sry for confusing with wrong patches.

Regards,

Dmitry.
