Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaKKLfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:35:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbaKKLKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>, Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 109/170] USB: option: add Haier CE81B CDMA modem
Date: Tue, 11 Nov 2014 11:07:48 +0000
Message-Id: <1415704129-12709-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 012eee1522318b5ccd64d277d50ac32f7e9974fe upstream.

Port layout:

0: QCDM/DIAG
1: NMEA
2: AT
3: AT/PPP

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 9c8d92348302..e87219a0f2f7 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -362,6 +362,7 @@ static void option_instat_callback(struct urb *urb);
 
 /* Haier products */
 #define HAIER_VENDOR_ID				0x201e
+#define HAIER_PRODUCT_CE81B			0x10f8
 #define HAIER_PRODUCT_CE100			0x2009
 
 /* Cinterion (formerly Siemens) products */
@@ -1620,6 +1621,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HAIER_VENDOR_ID, HAIER_PRODUCT_CE81B, 0xff, 0xff, 0xff) },
 	/* Pirelli  */
 	{ USB_DEVICE_INTERFACE_CLASS(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_1, 0xff) },
 	{ USB_DEVICE_INTERFACE_CLASS(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_2, 0xff) },
-- 
2.1.0

