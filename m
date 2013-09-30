Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3I3Kcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:32:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3I3KMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: AceLan Kao <acelan.kao@canonical.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 034/104] Bluetooth: Add support for Atheros [0cf3:e003]
Date: Mon, 30 Sep 2013 11:10:11 +0100
Message-Id: <1380535881-9239-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: AceLan Kao <acelan.kao@canonical.com>

commit 1d5b569ef85d013a775560a90050dc630614c045 upstream.

Add support for the AR9462 chip

T:  Bus=02 Lev=02 Prnt=02 Port=04 Cnt=01 Dev#=  4 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0cf3 ProdID=e003 Rev=00.02
C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index a9e5be4..5a757be 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -94,6 +94,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x04c5, 0x1330) },
 	{ USB_DEVICE(0x13d3, 0x3402) },
 	{ USB_DEVICE(0x0cf3, 0x3121) },
+	{ USB_DEVICE(0x0cf3, 0xe003) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -134,6 +135,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index b6a17c6..e17340f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -163,6 +163,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
-- 
1.8.3.2

