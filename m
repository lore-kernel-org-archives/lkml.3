Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3GQW4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:56:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934562Ab3GQW4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 035/145] USB: option,qcserial: move Novatel Gobi1K IDs to qcserial
Date: Wed, 17 Jul 2013 15:46:07 -0700
Message-Id: <1374101277-7915-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit a254810a86aaaac4ac6ba44fa934558b042a17a7 upstream.

These devices are all Gobi1K devices (according to the Windows INF
files) and should be handled by qcserial instead of option.  Their
network port is handled by qmi_wwan.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c   | 4 ----
 drivers/usb/serial/qcserial.c | 8 +++++++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 9162db2..c94fe3e 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -159,8 +159,6 @@ static void option_instat_callback(struct urb *urb);
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED	0x9000
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED	0x9001
 #define NOVATELWIRELESS_PRODUCT_E362		0x9010
-#define NOVATELWIRELESS_PRODUCT_G1		0xA001
-#define NOVATELWIRELESS_PRODUCT_G1_M		0xA002
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
 #define NOVATELWIRELESS_PRODUCT_MC551		0xB001
 
@@ -730,8 +728,6 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC547) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED) },
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G1) },
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G1_M) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G2) },
 	/* Novatel Ovation MC551 a.k.a. Verizon USB551L */
 	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC551, 0xff, 0xff, 0xff) },
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index bd794b4..c65437c 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -35,7 +35,13 @@ static const struct usb_device_id id_table[] = {
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
-- 
1.8.1.2

