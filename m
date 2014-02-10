Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaBJTrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:47:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbaBJTrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rahul Bedarkar <rahulbedarkar89@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 025/124] USB: serial: add support for iBall 3.5G connect usb modem
Date: Mon, 10 Feb 2014 11:39:25 -0800
Message-Id: <1392061264-28124-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Bedarkar <rahulbedarkar89@gmail.com>

commit 7d5c1b9c7cb5ec8e52b1adc65c484a923a8ea6c3 upstream.

Add support for iBall 3.5G connect usb modem.

$lsusb
Bus 002 Device 006: ID 1c9e:9605 OMEGA TECHNOLOGY

$usb-devices
T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  6 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1c9e ProdID=9605 Rev=00.00
S:  Manufacturer=USB Modem
S:  Product=USB Modem
S:  SerialNumber=1234567890ABCDEF
C:  #Ifs= 5 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#= 4 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
Suggested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 0657890..26ed554 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -320,6 +320,9 @@ static void option_instat_callback(struct urb *urb);
  * It seems to contain a Qualcomm QSC6240/6290 chipset            */
 #define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
 
+/* iBall 3.5G connect wireless modem */
+#define IBALL_3_5G_CONNECT			0x9605
+
 /* Zoom */
 #define ZOOM_PRODUCT_4597			0x9607
 
@@ -1500,6 +1503,7 @@ static const struct usb_device_id option_ids[] = {
   	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
   	},
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
+	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
 	/* Pirelli  */
 	{ USB_DEVICE_INTERFACE_CLASS(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_1, 0xff) },
-- 
1.8.3.2

