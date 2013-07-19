Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935087Ab3GSCXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:23:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934877Ab3GSCXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:23:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Williams <dcbw@redhat.com>
Subject: [ 03/18] USB: option,qcserial: move Novatel Gobi1K IDs to qcserial
Date: Thu, 18 Jul 2013 19:23:18 -0700
Message-Id: <20130719021049.199300664@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719021048.965829361@linuxfoundation.org>
References: <20130719021048.965829361@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit a254810a86aaaac4ac6ba44fa934558b042a17a7 upstream.

These devices are all Gobi1K devices (according to the Windows INF
files) and should be handled by qcserial instead of option.  Their
network port is handled by qmi_wwan.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c   |    4 ----
 drivers/usb/serial/qcserial.c |    8 +++++++-
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -159,8 +159,6 @@ static void option_instat_callback(struc
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED	0x9000
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED	0x9001
 #define NOVATELWIRELESS_PRODUCT_E362		0x9010
-#define NOVATELWIRELESS_PRODUCT_G1		0xA001
-#define NOVATELWIRELESS_PRODUCT_G1_M		0xA002
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
 #define NOVATELWIRELESS_PRODUCT_MC551		0xB001
 
@@ -744,8 +742,6 @@ static const struct usb_device_id option
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC547) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED) },
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G1) },
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G1_M) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G2) },
 	/* Novatel Ovation MC551 a.k.a. Verizon USB551L */
 	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC551, 0xff, 0xff, 0xff) },
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -36,7 +36,13 @@ static const struct usb_device_id id_tab
 	{DEVICE_G1K(0x04da, 0x250c)},	/* Panasonic Gobi QDL device */
 	{DEVICE_G1K(0x413c, 0x8172)},	/* Dell Gobi Modem device */
 	{DEVICE_G1K(0x413c, 0x8171)},	/* Dell Gobi QDL device */
-	{DEVICE_G1K(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa001)},	/* Novatel/Verizon USB-1000 */
+	{DEVICE_G1K(0x1410, 0xa002)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa003)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa004)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa005)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa006)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa007)},	/* Novatel Gobi Modem device */
 	{DEVICE_G1K(0x1410, 0xa008)},	/* Novatel Gobi QDL device */
 	{DEVICE_G1K(0x0b05, 0x1776)},	/* Asus Gobi Modem device */
 	{DEVICE_G1K(0x0b05, 0x1774)},	/* Asus Gobi QDL device */


