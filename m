Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3BCOzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34214 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011Ab3BCOzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:38 -0500
Message-Id: <20130203144647.414311122@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        =?ISO-8859-15?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 038/128] USB: option: add Telekom Speedstick LTE II
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

commit 5ec0085440ef8c2cf50002b34d5a504ee12aa2bf upstream.

also known as Alcatel One Touch L100V LTE

The driver description files gives these names to the vendor specific
functions on this modem:

 Application1: VID_1BBB&PID_011E&MI_00
 Application2: VID_1BBB&PID_011E&MI_01
 Modem:        VID_1BBB&PID_011E&MI_03
 Ethernet:     VID_1BBB&PID_011E&MI_04

Reported-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 4d85330..2c75d50 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -288,6 +288,7 @@ static void option_instat_callback(struct urb *urb);
 #define ALCATEL_VENDOR_ID			0x1bbb
 #define ALCATEL_PRODUCT_X060S_X200		0x0000
 #define ALCATEL_PRODUCT_X220_X500D		0x0017
+#define ALCATEL_PRODUCT_L100V			0x011e
 
 #define PIRELLI_VENDOR_ID			0x1266
 #define PIRELLI_PRODUCT_C100_1			0x1002
@@ -1194,6 +1195,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = (kernel_ulong_t)&alcatel_x200_blacklist
 	},
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X220_X500D) },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_L100V),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),


