Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546Ab3BSTKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:10:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934138Ab3BSSvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 30/81] USB: option: add Changhong CH690
Date: Tue, 19 Feb 2013 15:48:53 -0300
Message-Id: <1361299784-8830-31-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit d4fa681541aa7bf8570d03426dd7ba663a71c467 upstream.

New device with 3 serial interfaces:

 If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend) Sub=ff Prot=ff
 If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend) Sub=ff Prot=ff
 If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend) Sub=ff Prot=ff
 If#= 3 Alt= 0 #EPs= 2 Cls=08(stor) Sub=06 Prot=50

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index bafe018..5f4ce8e 100644
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
-- 
1.7.9.5

