Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab3APQFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:05:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36297 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab3APQFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 129/222] i2400m: add Intel 6150 device IDs
Date: Wed, 16 Jan 2013 13:55:29 -0200
Message-Id: <1358351822-7675-130-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 999a7c5776a0ed2133645fa7e008bec05bda9254 upstream.

Add device IDs for WiMAX function of Intel 6150 cards.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wimax/i2400m/i2400m-usb.h |    3 +++
 drivers/net/wimax/i2400m/usb.c        |    6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wimax/i2400m/i2400m-usb.h b/drivers/net/wimax/i2400m/i2400m-usb.h
index 6650fde..9f1e947 100644
--- a/drivers/net/wimax/i2400m/i2400m-usb.h
+++ b/drivers/net/wimax/i2400m/i2400m-usb.h
@@ -152,6 +152,9 @@ enum {
 	/* Device IDs */
 	USB_DEVICE_ID_I6050 = 0x0186,
 	USB_DEVICE_ID_I6050_2 = 0x0188,
+	USB_DEVICE_ID_I6150 = 0x07d6,
+	USB_DEVICE_ID_I6150_2 = 0x07d7,
+	USB_DEVICE_ID_I6150_3 = 0x07d9,
 	USB_DEVICE_ID_I6250 = 0x0187,
 };
 
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 713d033..080f363 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -510,6 +510,9 @@ int i2400mu_probe(struct usb_interface *iface,
 	switch (id->idProduct) {
 	case USB_DEVICE_ID_I6050:
 	case USB_DEVICE_ID_I6050_2:
+	case USB_DEVICE_ID_I6150:
+	case USB_DEVICE_ID_I6150_2:
+	case USB_DEVICE_ID_I6150_3:
 	case USB_DEVICE_ID_I6250:
 		i2400mu->i6050 = 1;
 		break;
@@ -759,6 +762,9 @@ static
 struct usb_device_id i2400mu_id_table[] = {
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050_2) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150_2) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150_3) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6250) },
 	{ USB_DEVICE(0x8086, 0x0181) },
 	{ USB_DEVICE(0x8086, 0x1403) },
-- 
1.7.9.5

