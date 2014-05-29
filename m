Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934923AbaE2OMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:12:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59383 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933252AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 048/103] usb: option: add Alcatel L800MA
Date: Thu, 29 May 2014 15:48:33 +0200
Message-Id: <42f2c7fb3ea7029dcde2387418b33538440c2a88.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dd6b48ecec2ea7d15f28d5e5474388681899a5e1 upstream.

Device interface layout:
0: ff/ff/ff - serial
1: ff/00/00 - serial AT+PPP
2: ff/ff/ff - QMI/wwan
3: 08/06/50 - storage

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/option.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 6335222cb892..776c86f3c091 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -287,6 +287,7 @@ static void option_instat_callback(struct urb *urb);
 #define ALCATEL_PRODUCT_X060S_X200		0x0000
 #define ALCATEL_PRODUCT_X220_X500D		0x0017
 #define ALCATEL_PRODUCT_L100V			0x011e
+#define ALCATEL_PRODUCT_L800MA			0x0203
 
 #define PIRELLI_VENDOR_ID			0x1266
 #define PIRELLI_PRODUCT_C100_1			0x1002
@@ -1501,6 +1502,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = (kernel_ulong_t)&net_intf5_blacklist },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_L100V),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_L800MA),
+	  .driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
-- 
1.9.3

