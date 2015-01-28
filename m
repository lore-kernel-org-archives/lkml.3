Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbbA1Es5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:48:57 -0500
Received: from mail.kernel.org ([198.145.29.136]:40105 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934328AbbA1EWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:48 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 098/177] USB: option: add Haier CE81B CDMA modem
Date: Wed, 28 Jan 2015 12:09:16 +0800
Message-Id: <1422418236-12852-189-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dcbw@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 012eee1522318b5ccd64d277d50ac32f7e9974fe upstream.

Port layout:

0: QCDM/DIAG
1: NMEA
2: AT
3: AT/PPP

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index f2786d4..d8232df 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -363,6 +363,7 @@ static void option_instat_callback(struct urb *urb);
 
 /* Haier products */
 #define HAIER_VENDOR_ID				0x201e
+#define HAIER_PRODUCT_CE81B			0x10f8
 #define HAIER_PRODUCT_CE100			0x2009
 
 /* Cinterion (formerly Siemens) products */
@@ -1622,6 +1623,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HAIER_VENDOR_ID, HAIER_PRODUCT_CE81B, 0xff, 0xff, 0xff) },
 	/* Pirelli  */
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_1)},
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_2)},
-- 
1.9.1

