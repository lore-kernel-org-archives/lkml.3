Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaGHN5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:57:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41844 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaGHN5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:57:09 -0400
From: Anantha Krishnan <ananthk@codeaurora.org>
To: marcel@holtmann.org
Cc: gustavo@padovan.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anantha Krishnan <ananthk@codeaurora.org>
Subject: [PATCH] Bluetooth: Add support for Acer [13D3:3432]
Date: Tue,  8 Jul 2014 19:25:08 +0530
Message-Id: <1404827708-23154-1-git-send-email-ananthk@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the QCA6174 chip.

    T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 30 Spd=12  MxCh= 0
    D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
    P:  Vendor=13d3 ProdID=3432 Rev=00.02
    C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
    I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
    I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Signed-off-by: Anantha Krishnan <ananthk@codeaurora.org>
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index f50dffc..a1fd940 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -103,6 +103,7 @@ static const struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x13d3, 0x3393) },
 	{ USB_DEVICE(0x13d3, 0x3402) },
+	{ USB_DEVICE(0x13d3, 0x3432) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -152,6 +153,7 @@ static const struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE036), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 6250fc2..9bc3d99 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -175,6 +175,7 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

