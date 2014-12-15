Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaLOPBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:01:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38506 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaLOO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anantha Krishnan <ananthk@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 064/168] Bluetooth: Add support for Acer [13D3:3432]
Date: Mon, 15 Dec 2014 14:25:18 +0000
Message-Id: <1418653622-21105-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anantha Krishnan <ananthk@codeaurora.org>

commit fa2f1394fe9c1a217213f02df77812701de6362f upstream.

Add support for the QCA6174 chip.

    T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 30 Spd=12  MxCh= 0
    D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
    P:  Vendor=13d3 ProdID=3432 Rev=00.02
    C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
    I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
    I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Signed-off-by: Anantha Krishnan <ananthk@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 095c4381f697..6b8c09dc3e55 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -104,6 +104,7 @@ static const struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x13d3, 0x3393) },
 	{ USB_DEVICE(0x13d3, 0x3402) },
+	{ USB_DEVICE(0x13d3, 0x3432) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -153,6 +154,7 @@ static const struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE036), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 0663fe85be29..a917f38f03ec 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -183,6 +183,7 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
-- 
2.1.3

