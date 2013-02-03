Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3BCO4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34354 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab3BCO4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:31 -0500
Message-Id: <20130203144649.810607752@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        =?ISO-8859-15?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 065/128] USB: option: add TP-LINK HSUPA Modem MA180
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 99beb2e9687ffd61c92a9875141eabe6f57a71b9 upstream.

The driver description files gives these names to the vendor specific
functions on this modem:

 Diagnostics VID_2357&PID_0201&MI_00
 NMEA        VID_2357&PID_0201&MI_01
 Modem       VID_2357&PID_0201&MI_03
 Networkcard VID_2357&PID_0201&MI_04

Reported-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 25724f6..0d9dac9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -449,6 +449,10 @@ static void option_instat_callback(struct urb *urb);
 #define PETATEL_VENDOR_ID			0x1ff4
 #define PETATEL_PRODUCT_NP10T			0x600e
 
+/* TP-LINK Incorporated products */
+#define TPLINK_VENDOR_ID			0x2357
+#define TPLINK_PRODUCT_MA180			0x0201
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1312,6 +1316,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
+	{ USB_DEVICE(TPLINK_VENDOR_ID, TPLINK_PRODUCT_MA180),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


