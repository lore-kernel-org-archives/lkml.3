Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab3BHBHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:07:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759633Ab3BHA6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 15/26] USB: option: add Changhong CH690
Date: Thu,  7 Feb 2013 16:57:43 -0800
Message-Id: <20130208004629.924589997@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -454,6 +454,10 @@ static void option_instat_callback(struc
 #define TPLINK_VENDOR_ID			0x2357
 #define TPLINK_PRODUCT_MA180			0x0201
 
+/* Changhong products */
+#define CHANGHONG_VENDOR_ID			0x2077
+#define CHANGHONG_PRODUCT_CH690			0x7001
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1326,6 +1330,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
 	{ USB_DEVICE(TPLINK_VENDOR_ID, TPLINK_PRODUCT_MA180),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(CHANGHONG_VENDOR_ID, CHANGHONG_PRODUCT_CH690) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


