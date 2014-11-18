Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbaKROj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:39:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbaKROKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 150/206] USB: option: add Haier CE81B CDMA modem
Date: Tue, 18 Nov 2014 15:08:25 +0100
Message-Id: <ced7ff3a7674c5127555ba3328edc636cda3c017.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dcbw@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 012eee1522318b5ccd64d277d50ac32f7e9974fe upstream.

Port layout:

0: QCDM/DIAG
1: NMEA
2: AT
3: AT/PPP

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 900e3ad541e3..8b3484134ab0 100644
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
2.1.3

