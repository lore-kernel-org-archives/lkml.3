Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaCaVOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:14:18 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45618 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaCaVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:14:16 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: khoroshilov@ispras.ru, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging/wlan-ng fix small coding style issues
Date: Mon, 31 Mar 2014 23:14:12 +0200
Message-Id: <1396300452-1904-1-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* improve readability of usb_prism_tbl[]
* remove obsolete comments for prism2sta_probe_usb() and
  prism2sta_disconnect_usb()
* delete some unneeded blank lines and add few ones to make
  checkpatch.pl happy.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/prism2usb.c | 163 +++++++++++-------------------------
 1 file changed, 51 insertions(+), 112 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 4739c14..bbe004a 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -4,103 +4,59 @@
 #include "prism2sta.c"
 #include "prism2fw.c"
 
-#define PRISM_USB_DEVICE(vid, pid, name)	\
-	USB_DEVICE(vid, pid),			\
-	.driver_info = (unsigned long) name
+#define PRISM_DEV(vid, pid, name)		\
+	{ USB_DEVICE(vid, pid),			\
+	.driver_info = (unsigned long) name }
 
 static struct usb_device_id usb_prism_tbl[] = {
-	{PRISM_USB_DEVICE(0x04bb, 0x0922, "IOData AirPort WN-B11/USBS")},
-	{PRISM_USB_DEVICE(0x07aa, 0x0012, "Corega Wireless LAN USB Stick-11")},
-	{PRISM_USB_DEVICE(0x09aa, 0x3642, "Prism2.x 11Mbps WLAN USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x1668, 0x0408, "Actiontec Prism2.5 11Mbps WLAN USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x1668, 0x0421, "Actiontec Prism2.5 11Mbps WLAN USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x1915, 0x2236, "Linksys WUSB11v3.0 11Mbps WLAN USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x066b, 0x2212, "Linksys WUSB11v2.5 11Mbps WLAN USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x066b, 0x2213, "Linksys WUSB12v1.1 11Mbps WLAN USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x067c, 0x1022, "Siemens SpeedStream 1022 11Mbps WLAN USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x049f, 0x0033,
-	 "Compaq/Intel W100 PRO/Wireless 11Mbps multiport WLAN Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x0411, 0x0016, "Melco WLI-USB-S11 11Mbps WLAN Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x08de, 0x7a01, "PRISM25 IEEE 802.11 Mini USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x8086, 0x1111, "Intel PRO/Wireless 2011B LAN USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x0d8e, 0x7a01, "PRISM25 IEEE 802.11 Mini USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x045e, 0x006e, "Microsoft MN510 Wireless USB Adapter")},
-	{PRISM_USB_DEVICE(0x0967, 0x0204, "Acer Warplink USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x0cde, 0x0002, "Z-Com 725/726 Prism2.5 USB/USB Integrated")},
-	{PRISM_USB_DEVICE
-	 (0x0cde, 0x0005, "Z-Com Xl735 Wireless 802.11b USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x413c, 0x8100, "Dell TrueMobile 1180 Wireless USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x0b3b, 0x1601, "ALLNET 0193 11Mbps WLAN USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x0b3b, 0x1602, "ZyXEL ZyAIR B200 Wireless USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x0baf, 0x00eb, "USRobotics USR1120 Wireless USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x0411, 0x0027, "Melco WLI-USB-KS11G 11Mbps WLAN Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x04f1, 0x3009, "JVC MP-XP7250 Builtin USB WLAN Adapter")},
-	{PRISM_USB_DEVICE(0x0846, 0x4110, "NetGear MA111")},
-	{PRISM_USB_DEVICE(0x03f3, 0x0020, "Adaptec AWN-8020 USB WLAN Adapter")},
-	{PRISM_USB_DEVICE(0x2821, 0x3300, "ASUS-WL140 Wireless USB Adapter")},
-	{PRISM_USB_DEVICE(0x2001, 0x3700, "DWL-122 Wireless USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x2001, 0x3702, "DWL-120 Rev F Wireless USB Adapter")},
-	{PRISM_USB_DEVICE(0x50c2, 0x4013, "Averatec USB WLAN Adapter")},
-	{PRISM_USB_DEVICE(0x2c02, 0x14ea, "Planex GW-US11H WLAN USB Adapter")},
-	{PRISM_USB_DEVICE(0x124a, 0x168b, "Airvast PRISM3 WLAN USB Adapter")},
-	{PRISM_USB_DEVICE(0x083a, 0x3503, "T-Sinus 111 USB WLAN Adapter")},
-	{PRISM_USB_DEVICE(0x2821, 0x3300, "Hawking HighDB USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x0411, 0x0044, "Melco WLI-USB-KB11 11Mbps WLAN Adapter")},
-	{PRISM_USB_DEVICE(0x1668, 0x6106, "ROPEX FreeLan 802.11b USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x124a, 0x4017, "Pheenet WL-503IA 802.11b USB Adapter")},
-	{PRISM_USB_DEVICE(0x0bb2, 0x0302, "Ambit Microsystems Corp.")},
-	{PRISM_USB_DEVICE
-	 (0x9016, 0x182d, "Sitecom WL-022 802.11b USB Adapter")},
-	{PRISM_USB_DEVICE
-	 (0x0543, 0x0f01, "ViewSonic Airsync USB Adapter 11Mbps (Prism2.5)")},
-	{ /* terminator */ }
+	PRISM_DEV(0x04bb, 0x0922, "IOData AirPort WN-B11/USBS"),
+	PRISM_DEV(0x07aa, 0x0012, "Corega Wireless LAN USB Stick-11"),
+	PRISM_DEV(0x09aa, 0x3642, "Prism2.x 11Mbps WLAN USB Adapter"),
+	PRISM_DEV(0x1668, 0x0408, "Actiontec Prism2.5 11Mbps WLAN USB Adapter"),
+	PRISM_DEV(0x1668, 0x0421, "Actiontec Prism2.5 11Mbps WLAN USB Adapter"),
+	PRISM_DEV(0x1915, 0x2236, "Linksys WUSB11v3.0 11Mbps WLAN USB Adapter"),
+	PRISM_DEV(0x066b, 0x2212, "Linksys WUSB11v2.5 11Mbps WLAN USB Adapter"),
+	PRISM_DEV(0x066b, 0x2213, "Linksys WUSB12v1.1 11Mbps WLAN USB Adapter"),
+	PRISM_DEV(0x0411, 0x0016, "Melco WLI-USB-S11 11Mbps WLAN Adapter"),
+	PRISM_DEV(0x08de, 0x7a01, "PRISM25 IEEE 802.11 Mini USB Adapter"),
+	PRISM_DEV(0x8086, 0x1111, "Intel PRO/Wireless 2011B LAN USB Adapter"),
+	PRISM_DEV(0x0d8e, 0x7a01, "PRISM25 IEEE 802.11 Mini USB Adapter"),
+	PRISM_DEV(0x045e, 0x006e, "Microsoft MN510 Wireless USB Adapter"),
+	PRISM_DEV(0x0967, 0x0204, "Acer Warplink USB Adapter"),
+	PRISM_DEV(0x0cde, 0x0002, "Z-Com 725/726 Prism2.5 USB/USB Integrated"),
+	PRISM_DEV(0x0cde, 0x0005, "Z-Com Xl735 Wireless 802.11b USB Adapter"),
+	PRISM_DEV(0x413c, 0x8100, "Dell TrueMobile 1180 Wireless USB Adapter"),
+	PRISM_DEV(0x0b3b, 0x1601, "ALLNET 0193 11Mbps WLAN USB Adapter"),
+	PRISM_DEV(0x0b3b, 0x1602, "ZyXEL ZyAIR B200 Wireless USB Adapter"),
+	PRISM_DEV(0x0baf, 0x00eb, "USRobotics USR1120 Wireless USB Adapter"),
+	PRISM_DEV(0x0411, 0x0027, "Melco WLI-USB-KS11G 11Mbps WLAN Adapter"),
+	PRISM_DEV(0x04f1, 0x3009, "JVC MP-XP7250 Builtin USB WLAN Adapter"),
+	PRISM_DEV(0x0846, 0x4110, "NetGear MA111"),
+	PRISM_DEV(0x03f3, 0x0020, "Adaptec AWN-8020 USB WLAN Adapter"),
+	PRISM_DEV(0x2821, 0x3300, "ASUS-WL140 Wireless USB Adapter"),
+	PRISM_DEV(0x2001, 0x3700, "DWL-122 Wireless USB Adapter"),
+	PRISM_DEV(0x2001, 0x3702, "DWL-120 Rev F Wireless USB Adapter"),
+	PRISM_DEV(0x50c2, 0x4013, "Averatec USB WLAN Adapter"),
+	PRISM_DEV(0x2c02, 0x14ea, "Planex GW-US11H WLAN USB Adapter"),
+	PRISM_DEV(0x124a, 0x168b, "Airvast PRISM3 WLAN USB Adapter"),
+	PRISM_DEV(0x083a, 0x3503, "T-Sinus 111 USB WLAN Adapter"),
+	PRISM_DEV(0x2821, 0x3300, "Hawking HighDB USB Adapter"),
+	PRISM_DEV(0x0411, 0x0044, "Melco WLI-USB-KB11 11Mbps WLAN Adapter"),
+	PRISM_DEV(0x1668, 0x6106, "ROPEX FreeLan 802.11b USB Adapter"),
+	PRISM_DEV(0x124a, 0x4017, "Pheenet WL-503IA 802.11b USB Adapter"),
+	PRISM_DEV(0x0bb2, 0x0302, "Ambit Microsystems Corp."),
+	PRISM_DEV(0x9016, 0x182d, "Sitecom WL-022 802.11b USB Adapter"),
+	PRISM_DEV(0x0543, 0x0f01,
+		"ViewSonic Airsync USB Adapter 11Mbps (Prism2.5)"),
+	PRISM_DEV(0x067c, 0x1022,
+		"Siemens SpeedStream 1022 11Mbps WLAN USB Adapter"),
+	PRISM_DEV(0x049f, 0x0033,
+		"Compaq/Intel W100 PRO/Wireless 11Mbps multiport WLAN Adapter"),
+	{ } /* terminator */
 };
 
 MODULE_DEVICE_TABLE(usb, usb_prism_tbl);
 
-/*----------------------------------------------------------------
-* prism2sta_probe_usb
-*
-* Probe routine called by the USB subsystem.
-*
-* Arguments:
-*	dev		ptr to the usb_device struct
-*	ifnum		interface number being offered
-*
-* Returns:
-*	NULL		- we're not claiming the device+interface
-*	non-NULL	- we are claiming the device+interface and
-*			  this is a ptr to the data we want back
-*			  when disconnect is called.
-*
-* Side effects:
-*
-* Call context:
-*	I'm not sure, assume it's interrupt.
-*
-----------------------------------------------------------------*/
 static int prism2sta_probe_usb(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
@@ -176,31 +132,11 @@ done:
 	return result;
 }
 
-/*----------------------------------------------------------------
-* prism2sta_disconnect_usb
-*
-* Called when a device previously claimed by probe is removed
-* from the USB.
-*
-* Arguments:
-*	dev		ptr to the usb_device struct
-*	ptr		ptr returned by probe() when the device
-*                       was claimed.
-*
-* Returns:
-*	Nothing
-*
-* Side effects:
-*
-* Call context:
-*	process
-----------------------------------------------------------------*/
 static void prism2sta_disconnect_usb(struct usb_interface *interface)
 {
 	wlandevice_t *wlandev;
 
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
-
 	if (wlandev != NULL) {
 		LIST_HEAD(cleanlist);
 		struct list_head *entry;
@@ -292,6 +228,7 @@ static int prism2sta_suspend(struct usb_interface *interface,
 {
 	hfa384x_t *hw = NULL;
 	wlandevice_t *wlandev;
+
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
 	if (!wlandev)
 		return -ENODEV;
@@ -314,6 +251,7 @@ static int prism2sta_resume(struct usb_interface *interface)
 	int result = 0;
 	hfa384x_t *hw = NULL;
 	wlandevice_t *wlandev;
+
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
 	if (!wlandev)
 		return -ENODEV;
@@ -330,7 +268,8 @@ static int prism2sta_resume(struct usb_interface *interface)
 		if (result != 0) {
 			unregister_wlandev(wlandev);
 			hfa384x_destroy(hw);
-			dev_err(&interface->dev, "hfa384x_corereset() failed.\n");
+			dev_err(&interface->dev,
+				"hfa384x_corereset() failed.\n");
 			kfree(wlandev);
 			kfree(hw);
 			wlandev = NULL;
-- 
1.9.0

