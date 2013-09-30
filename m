Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3I3KcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:32:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3I3KMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Cho, Yu-Chen" <acho@suse.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 031/104] Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]
Date: Mon, 30 Sep 2013 11:10:08 +0100
Message-Id: <1380535881-9239-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Cho, Yu-Chen" <acho@suse.com>

commit 178c059e7640aa8e50213400c6f3dde00189d979 upstream.

This patch adds support for Mediatek Bluetooth device

T:  Bus=02 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.01 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0e8d ProdID=763f Rev= 1.00
S:  Manufacturer=MediaTek
S:  Product=BT
S:  SerialNumber=1.0
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=450mA
A:  FirstIf#= 0 IfCount= 2 Cls=ff(vend.) Sub=ff Prot=ff
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=125us
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
I:  If#= 1 Alt= 6 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms

Signed-off-by: Cho, Yu-Chen <acho@suse.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index bb480fd..5cdfd34 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -63,6 +63,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple-specific (Broadcom) devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
 
+	/* MediaTek MT76x0E */
+	{ USB_DEVICE(0x0e8d, 0x763f) },
+
 	/* Broadcom SoftSailing reporting vendor specific */
 	{ USB_DEVICE(0x0a5c, 0x21e1) },
 
-- 
1.8.3.2

