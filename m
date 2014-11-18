Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbaKRPON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:14:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbaKROJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marco Piazza <mpiazza@gmail.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 032/206] Bluetooth: Add support for Toshiba Bluetooth device [0930:0220]
Date: Tue, 18 Nov 2014 15:06:27 +0100
Message-Id: <0d6a4578644f00624cb663c6e7cc7d14abad1206.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Piazza <mpiazza@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bd0976dd3379e790b031cef7f477c58b82a65fc2 upstream.

This patch adds support for new Toshiba Bluetooth device.

T:  Bus=05 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#=  4 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0930 ProdID=0220 Rev=00.02
C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Signed-off-by: Marco Piazza <mpiazza@gmail.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bluetooth/ath3k.c | 2 ++
 drivers/bluetooth/btusb.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index d38a94bc1cbf..6b4ba50ed327 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -90,6 +90,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x0CF3, 0xE004) },
 	{ USB_DEVICE(0x0CF3, 0xE005) },
 	{ USB_DEVICE(0x0930, 0x0219) },
+	{ USB_DEVICE(0x0930, 0x0220) },
 	{ USB_DEVICE(0x0489, 0xe057) },
 	{ USB_DEVICE(0x13d3, 0x3393) },
 	{ USB_DEVICE(0x0489, 0xe04e) },
@@ -135,6 +136,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe005), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0220), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 86bf57f79098..6d169f3c98e1 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -167,6 +167,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe005), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0220), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
-- 
2.1.3

