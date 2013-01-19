Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3ASBXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:23:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:57311 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab3ASBWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:22:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 13/16] USB: option: add TP-LINK HSUPA Modem MA180
Date: Fri, 18 Jan 2013 17:21:51 -0800
Message-Id: <20130119012140.203089164@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119012138.680057206@linuxfoundation.org>
References: <20130119012138.680057206@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -449,6 +449,10 @@ static void option_instat_callback(struc
 #define PETATEL_VENDOR_ID			0x1ff4
 #define PETATEL_PRODUCT_NP10T			0x600e
 
+/* TP-LINK Incorporated products */
+#define TPLINK_VENDOR_ID			0x2357
+#define TPLINK_PRODUCT_MA180			0x0201
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1311,6 +1315,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
+	{ USB_DEVICE(TPLINK_VENDOR_ID, TPLINK_PRODUCT_MA180),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


