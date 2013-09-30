Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3I3Kd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:33:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3I3KMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Loo <tloo@saltstorm.net>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 032/104] Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]
Date: Mon, 30 Sep 2013 11:10:09 +0100
Message-Id: <1380535881-9239-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Loo <tloo@saltstorm.net>

commit 84eb2ae1807dd1467bf6f500fc69ae61f1907b75 upstream.

The Fujitsu Lifebook UH552/UH572 ships with a Qualcomm AR9462/AR3012
WLAN/BT-Combo card.
Add device ID to the ath3k driver to enable the bluetooth side of things.
Patch against v3.10.

T:  Bus=03 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  3 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=04c5 ProdID=1330 Rev=00.02
C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Signed-off-by: Thomas Loo <tloo@saltstorm.net>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 2b912cc..3e7e2ee 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -91,6 +91,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x0489, 0xe04e) },
 	{ USB_DEVICE(0x0489, 0xe056) },
 	{ USB_DEVICE(0x0489, 0xe04d) },
+	{ USB_DEVICE(0x04c5, 0x1330) },
 	{ USB_DEVICE(0x0cf3, 0x3121) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
@@ -129,6 +130,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 5cdfd34..93fb265 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -160,6 +160,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
-- 
1.8.3.2

