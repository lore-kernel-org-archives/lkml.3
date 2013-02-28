Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab3B1PN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:13:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42095 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3B1Ors (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 049/139] USB: option: add Huawei "ACM" devices using protocol = vendor
Date: Thu, 28 Feb 2013 14:43:19 +0000
Message-Id: <1362062689-2567-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 3e5c9fe..bbaa45d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -578,8 +578,12 @@ static const struct usb_device_id option_ids[] = {
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
-- 
1.8.1.2

