Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3HQALx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:11:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51652 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab3HPWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: enrico Mioso <mrkiko.rs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 037/133] usb: serial: option: blacklist ONDA MT689DC QMI interface
Date: Fri, 16 Aug 2013 15:32:59 -0700
Message-Id: <1376692475-28413-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enrico Mioso <mrkiko.rs@gmail.com>

commit 3d1a69e726406ab662ab88fa30a3a05ed404334d upstream.

Prevent the option driver from binding itself to the QMI/WWAN interface, making
it unusable by the proper driver.

Signed-off-by: enrico Mioso <mrkiko.rs@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 9736e9b..1c8733a 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -819,7 +819,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0017, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0018, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0019, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0019, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0020, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0021, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
-- 
1.8.1.2

