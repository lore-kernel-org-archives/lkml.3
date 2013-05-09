Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3EIW2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:28:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3EIW04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Williams <dcbw@redhat.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 71/73] qmi_wwan/cdc_ether: add device IDs for Dell 5804 (Novatel E371) WWAN card
Date: Thu,  9 May 2013 15:26:01 -0700
Message-Id: <20130509222533.609023307@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 7fdb7846c9ca6fc06e380de0976a1228703b498a upstream.

A rebranded Novatel E371 for AT&T's LTE bands.  qmi_wwan should drive this
device, while cdc_ether should ignore it.  Even though the USB descriptors
are plain CDC-ETHER that USB interface is a QMI interface.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/cdc_ether.c |    7 +++++++
 drivers/net/usb/qmi_wwan.c  |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -615,6 +615,13 @@ static const struct usb_device_id	produc
 	.driver_info = 0,
 },
 
+/* Dell Wireless 5804 (Novatel E371) - handled by qmi_wwan */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x819b, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* AnyDATA ADU960S - handled by qmi_wwan */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(0x16d5, 0x650a, USB_CLASS_COMM,
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -496,6 +496,13 @@ static const struct usb_device_id produc
 					      USB_CDC_PROTO_NONE),
 		.driver_info        = (unsigned long)&qmi_wwan_info,
 	},
+	{	/* Dell Wireless 5804 (Novatel E371) */
+		USB_DEVICE_AND_INTERFACE_INFO(0x413C, 0x819b,
+					      USB_CLASS_COMM,
+					      USB_CDC_SUBCLASS_ETHERNET,
+					      USB_CDC_PROTO_NONE),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
 	{	/* ADU960S */
 		USB_DEVICE_AND_INTERFACE_INFO(0x16d5, 0x650a,
 					      USB_CLASS_COMM,


