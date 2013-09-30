Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3I3Cs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 22:48:56 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:46321 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3I3CsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 22:48:20 -0400
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Robert de Vries <rhdv@xs4all.nl>, Hayes Wang <hayeswang@realtek.com>,
        Freddy Xin <freddy@asix.com.tw>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Liu Junliang <liujunliang_ljl@163.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-usb@vger.kernel.org (open list:USB NETWORKING DR...),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        ModemManager-devel@lists.freedesktop.org
Cc: Enrico Mioso <mrkiko.rs@gmail.com>
Subject: [PATCH V5 net-next 3/3] net: cdc_ncm: remove non-standard NCM device IDs
Date: Mon, 30 Sep 2013 04:50:09 +0000
Message-Id: <1380516609-31242-4-git-send-email-mrkiko.rs@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380516609-31242-1-git-send-email-mrkiko.rs@gmail.com>
References: <1380516609-31242-1-git-send-email-mrkiko.rs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove device IDs of NCM-like (but not NCM-conformant) devices, that are
handled by the huawwei_cdc_ncm driver now.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 62686be..31f43f7 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1236,17 +1236,6 @@ static const struct usb_device_id cdc_devs[] = {
 	  .driver_info = (unsigned long)&wwan_info,
 	},
 
-	/* Huawei NCM devices disguised as vendor specific */
-	{ USB_VENDOR_AND_INTERFACE_INFO(0x12d1, 0xff, 0x02, 0x16),
-	  .driver_info = (unsigned long)&wwan_info,
-	},
-	{ USB_VENDOR_AND_INTERFACE_INFO(0x12d1, 0xff, 0x02, 0x46),
-	  .driver_info = (unsigned long)&wwan_info,
-	},
-	{ USB_VENDOR_AND_INTERFACE_INFO(0x12d1, 0xff, 0x02, 0x76),
-	  .driver_info = (unsigned long)&wwan_info,
-	},
-
 	/* Infineon(now Intel) HSPA Modem platform */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1519, 0x0443,
 		USB_CLASS_COMM,
-- 
1.8.4

