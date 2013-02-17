Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3BQXI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:08:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45612 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747Ab3BQWzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:01 -0500
Message-Id: <20130217225003.882412639@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 19/66] USB: option: add Changhong CH690
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit d4fa681541aa7bf8570d03426dd7ba663a71c467 upstream.

New device with 3 serial interfaces:

 If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend) Sub=ff Prot=ff
 If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend) Sub=ff Prot=ff
 If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend) Sub=ff Prot=ff
 If#= 3 Alt= 0 #EPs= 2 Cls=08(stor) Sub=06 Prot=50

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 384bb92..567bc77 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -454,6 +454,10 @@ static void option_instat_callback(struct urb *urb);
 #define TPLINK_VENDOR_ID			0x2357
 #define TPLINK_PRODUCT_MA180			0x0201
 
+/* Changhong products */
+#define CHANGHONG_VENDOR_ID			0x2077
+#define CHANGHONG_PRODUCT_CH690			0x7001
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1326,6 +1330,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
 	{ USB_DEVICE(TPLINK_VENDOR_ID, TPLINK_PRODUCT_MA180),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(CHANGHONG_VENDOR_ID, CHANGHONG_PRODUCT_CH690) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


