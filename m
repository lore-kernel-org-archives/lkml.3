Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab3APQA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:00:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3APQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 047/222] USB: option: blacklist network interface on Huawei E173
Date: Wed, 16 Jan 2013 13:54:07 -0200
Message-Id: <1358351822-7675-48-git-send-email-herton.krzesinski@canonical.com>
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

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit f36446cf9bbebaa03a80d95cfeeafbaf68218249 upstream.

The Huawei E173 will normally appear as 12d1:1436 in Linux.  But
the modem has another mode with different device ID and a slightly
different set of descriptors. This is the mode used by Windows like
this:

  3Modem:      USB\VID_12D1&PID_140C&MI_00\6&3A1D2012&0&0000
  Networkcard: USB\VID_12D1&PID_140C&MI_01\6&3A1D2012&0&0001
  Appli.Inter: USB\VID_12D1&PID_140C&MI_02\6&3A1D2012&0&0002
  PC UI Inter: USB\VID_12D1&PID_140C&MI_03\6&3A1D2012&0&0003

All interfaces have the same ff/ff/ff class codes in this mode.
Blacklisting the network interface to allow it to be picked up by
the network driver.

Reported-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 51ba561..2896ae5 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -80,6 +80,7 @@ static void option_instat_callback(struct urb *urb);
 #define OPTION_PRODUCT_GTM380_MODEM		0x7201
 
 #define HUAWEI_VENDOR_ID			0x12D1
+#define HUAWEI_PRODUCT_E173			0x140C
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_K4605			0x14C6
@@ -552,6 +553,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GLX) },
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GKE) },
 	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GLE) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff),
-- 
1.7.9.5

