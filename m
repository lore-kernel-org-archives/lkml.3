Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab3APQf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:35:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36310 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab3APQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 132/222] qmi_wwan/cdc_ether: add Dell Wireless 5800 (Novatel E362) USB IDs
Date: Wed, 16 Jan 2013 13:55:32 -0200
Message-Id: <1358351822-7675-133-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 0370acd4d4d2595a11b0b0a793acb506e19b9d4c upstream.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/usb/cdc_ether.c |   15 +++++++++++++++
 drivers/net/usb/qmi_wwan.c  |   14 ++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index d012982..c4c593d 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -487,6 +487,7 @@ static const struct driver_info wwan_info = {
 #define HUAWEI_VENDOR_ID	0x12D1
 #define NOVATEL_VENDOR_ID	0x1410
 #define ZTE_VENDOR_ID		0x19D2
+#define DELL_VENDOR_ID		0x413C
 
 static const struct usb_device_id	products [] = {
 /*
@@ -618,6 +619,20 @@ static const struct usb_device_id	products [] = {
 	.driver_info = 0,
 },
 
+/* Dell Wireless 5800 (Novatel E362) - handled by qmi_wwan */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x8195, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
+/* Dell Wireless 5800 (Novatel E362) - handled by qmi_wwan */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x8196, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /*
  * WHITELIST!!!
  *
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 466af29..e064b1d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -593,6 +593,20 @@ static const struct usb_device_id products[] = {
 		                              USB_CDC_PROTO_NONE),
 		.driver_info        = (unsigned long)&qmi_wwan_info,
 	},
+	{	/* Dell Wireless 5800 (Novatel E362) */
+		USB_DEVICE_AND_INTERFACE_INFO(0x413C, 0x8195,
+					      USB_CLASS_COMM,
+					      USB_CDC_SUBCLASS_ETHERNET,
+					      USB_CDC_PROTO_NONE),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
+	{	/* Dell Wireless 5800 V2 (Novatel E362) */
+		USB_DEVICE_AND_INTERFACE_INFO(0x413C, 0x8196,
+					      USB_CLASS_COMM,
+					      USB_CDC_SUBCLASS_ETHERNET,
+					      USB_CDC_PROTO_NONE),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
 
 	/* Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
1.7.9.5

