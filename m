Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab3E1VWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:22:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59547 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab3E1VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 21/78] qmi_wwan, cdc-ether: add ADU960S
Date: Tue, 28 May 2013 14:19:30 -0700
Message-Id: <1369776027-17859-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 45d213f5f8733ab4b5b2424b21c0034d54c5a866 upstream.

It advertises a standard CDC-ETHER interface, which actually should be
driven by qmi_wwan.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: selected for 3.8 stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/qmi_wwan.c  | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 3f3d12d..57136dc 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -615,6 +615,13 @@ static const struct usb_device_id	products [] = {
 	.driver_info = 0,
 },
 
+/* AnyDATA ADU960S - handled by qmi_wwan */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(0x16d5, 0x650a, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /*
  * WHITELIST!!!
  *
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index b69ca0f..968d5d5 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -392,6 +392,13 @@ static const struct usb_device_id products[] = {
 					      USB_CDC_PROTO_NONE),
 		.driver_info        = (unsigned long)&qmi_wwan_info,
 	},
+	{	/* ADU960S */
+		USB_DEVICE_AND_INTERFACE_INFO(0x16d5, 0x650a,
+					      USB_CLASS_COMM,
+					      USB_CDC_SUBCLASS_ETHERNET,
+					      USB_CDC_PROTO_NONE),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
-- 
1.8.1.2

