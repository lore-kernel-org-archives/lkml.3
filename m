Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965866AbaFQQyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:54:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50585 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933936AbaFQQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:18:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 045/121] usb: option: add Alcatel L800MA
Date: Tue, 17 Jun 2014 09:17:03 -0700
Message-Id: <1403021899-16708-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit dd6b48ecec2ea7d15f28d5e5474388681899a5e1 upstream.

Device interface layout:
0: ff/ff/ff - serial
1: ff/00/00 - serial AT+PPP
2: ff/ff/ff - QMI/wwan
3: 08/06/50 - storage

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5aa3512..b496887 100644
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
1.9.1

