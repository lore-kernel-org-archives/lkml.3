Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233Ab3AOXLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:11:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:48062 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934085Ab3AOW4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:56:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 20/71] i2400m: add Intel 6150 device IDs
Date: Tue, 15 Jan 2013 14:54:17 -0800
Message-Id: <20130115225341.892642216@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 999a7c5776a0ed2133645fa7e008bec05bda9254 upstream.

Add device IDs for WiMAX function of Intel 6150 cards.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wimax/i2400m/i2400m-usb.h |    3 +++
 drivers/net/wimax/i2400m/usb.c        |    6 ++++++
 2 files changed, 9 insertions(+)

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
 
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -491,6 +491,9 @@ int i2400mu_probe(struct usb_interface *
 	switch (id->idProduct) {
 	case USB_DEVICE_ID_I6050:
 	case USB_DEVICE_ID_I6050_2:
+	case USB_DEVICE_ID_I6150:
+	case USB_DEVICE_ID_I6150_2:
+	case USB_DEVICE_ID_I6150_3:
 	case USB_DEVICE_ID_I6250:
 		i2400mu->i6050 = 1;
 		break;
@@ -740,6 +743,9 @@ static
 struct usb_device_id i2400mu_id_table[] = {
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050_2) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150_2) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150_3) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6250) },
 	{ USB_DEVICE(0x8086, 0x0181) },
 	{ USB_DEVICE(0x8086, 0x1403) },


