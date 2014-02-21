Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbaBUNCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:02:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47841 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbaBUNCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Raymond Wanyoike <raymond.wanyoike@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 53/60] usb: option: blacklist ZTE MF667 net interface
Date: Fri, 21 Feb 2014 13:01:20 +0000
Message-Id: <1392987687-15367-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raymond Wanyoike <raymond.wanyoike@gmail.com>

commit 3635c7e2d59f7861afa6fa5e87e2a58860ff514d upstream.

Interface #5 of 19d2:1270 is a net interface which has been submitted to the
qmi_wwan driver so consequently remove it from the option driver.

Signed-off-by: Raymond Wanyoike <raymond.wanyoike@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 83b50db..e681037 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1376,7 +1376,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1267, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1268, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1269, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1270, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1270, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&net_intf5_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1271, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1272, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1273, 0xff, 0xff, 0xff) },
-- 
1.9.0

