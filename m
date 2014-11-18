Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaKRPPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:15:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbaKROJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sujith Manoharan <sujith@msujith.org>,
        Marcel Holtmann <marcel@holtmann.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 030/206] Bluetooth: ath3k: Add support for another AR3012 card
Date: Tue, 18 Nov 2014 15:06:25 +0100
Message-Id: <1adfda065f0d9d74a6e2bcd0fa5e94347dc6f6ab.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sujith Manoharan <sujith@msujith.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bd0fca1b2be8c96dfc391a2bc2ee4ce6970ae6af upstream.

T:  Bus=03 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=04ca ProdID=300b Rev= 0.01
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
A:  FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=01
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Reported-by: Face <falazemi@gmail.com>
Signed-off-by: Sujith Manoharan <sujith@msujith.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index c7ea25618f34..70c4ceaf4eee 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -85,6 +85,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x04CA, 0x3006) },
 	{ USB_DEVICE(0x04CA, 0x3007) },
 	{ USB_DEVICE(0x04CA, 0x3008) },
+	{ USB_DEVICE(0x04CA, 0x300b) },
 	{ USB_DEVICE(0x13d3, 0x3362) },
 	{ USB_DEVICE(0x0CF3, 0xE004) },
 	{ USB_DEVICE(0x0CF3, 0xE005) },
@@ -128,6 +129,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3007), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x300b), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe005), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fbcb6df05aaa..ec1640ddd10e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -162,6 +162,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3007), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x300b), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe005), .driver_info = BTUSB_ATH3012 },
-- 
2.1.3

