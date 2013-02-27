Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab3B0AKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:10:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759744Ab3B0AJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 83/86] USB: option: add Huawei "ACM" devices using protocol = vendor
Date: Tue, 26 Feb 2013 16:08:31 -0800
Message-Id: <20130226235921.538649486@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 1f3f687722fd9b29a0c2a85b4844e3b2a3585c63 upstream.

The USB device descriptor of one identity presented by a few
Huawei morphing devices have serial functions with class codes
02/02/ff, indicating CDC ACM with a vendor specific protocol. This
combination is often used for MSFT RNDIS functions, and the CDC
ACM class driver will therefore ignore such functions.

The CDC ACM class driver cannot support functions with only 2
endpoints.  The underlying serial functions of these modems are
also believed to be the same as for alternate device identities
already supported by the option driver. Letting the same driver
handle these functions independently of the current identity
ensures consistent handling and user experience.

There is no need to blacklist these devices in the rndis_host
driver. Huawei serial functions will either have only 2 endpoints
or a CDC ACM functional descriptor with bmCapabilities != 0, making
them correctly ignored as "non RNDIS" by that driver.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -578,8 +578,12 @@ static const struct usb_device_id option
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GLE) },
 	{ USB_DEVICE(QUANTA_VENDOR_ID, 0xea42),
 		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c05, USB_CLASS_COMM, 0x02, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c23, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1441, USB_CLASS_COMM, 0x02, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1442, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff),


