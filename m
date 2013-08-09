Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400Ab3HICLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:11:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967651Ab3HIB7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        AceLan Kao <acelan.kao@canonical.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 050/102] Bluetooth: Add support for Atheros [0cf3:e003]
Date: Thu,  8 Aug 2013 18:57:26 -0700
Message-Id: <20130809015021.794997730@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/ath3k.c |    2 ++
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -94,6 +94,7 @@ static struct usb_device_id ath3k_table[
 	{ USB_DEVICE(0x04c5, 0x1330) },
 	{ USB_DEVICE(0x13d3, 0x3402) },
 	{ USB_DEVICE(0x0cf3, 0x3121) },
+	{ USB_DEVICE(0x0cf3, 0xe003) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -134,6 +135,7 @@ static struct usb_device_id ath3k_blist_
 	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -154,6 +154,7 @@ static struct usb_device_id blacklist_ta
 	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },


