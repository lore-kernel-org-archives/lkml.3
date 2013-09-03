Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab3ICQak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:30:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab3ICQ3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:29:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Noguchi Kazutosi <linux@mofmof.scaltinof.net>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 29/58] Bluetooth: Add support for Foxconn/Hon Hai [0489:e04d]
Date: Tue,  3 Sep 2013 09:23:33 -0700
Message-Id: <1378225442-20654-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Noguchi Kazutosi <linux@scaltinof.net>

commit 0fc110f4e4f569e12c472f73f0af485e05631403 upstream.

Add support for the AR3012 chip.

T:  Bus=01 Lev=02 Prnt=02 Port=05 Cnt=03 Dev#= 21 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e04d Rev=00.02
S:  Manufacturer=Atheros Communications
S:  Product=Bluetooth USB Host Controller
S:  SerialNumber=Alaska Day 2006
C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Signed-off-by: Noguchi Kazutosi <linux@scaltinof.net>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 8af01c1..86c771d 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -90,6 +90,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3393) },
 	{ USB_DEVICE(0x0489, 0xe04e) },
 	{ USB_DEVICE(0x0489, 0xe056) },
+	{ USB_DEVICE(0x0489, 0xe04d) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -126,6 +127,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2cc5f77..b82c0964 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -148,6 +148,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
-- 
1.8.1.2

