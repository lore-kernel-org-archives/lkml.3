Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab3J1PDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:03:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51103 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab3J1OtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 22/64] USB: serial: option: add support for Inovia SEW858 device
Date: Mon, 28 Oct 2013 14:47:41 +0000
Message-Id: <1382971703-17393-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f4c19b8e165cff1a6607c21f8809441d61cab7ec upstream.

This patch adds the device id for the Inovia SEW858 device to the option driver.

Reported-by: Pavel Parkhomenko <ra85551@gmail.com>
Tested-by: Pavel Parkhomenko <ra85551@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 743ce6b..4460d63 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -457,6 +457,10 @@ static void option_instat_callback(struct urb *urb);
 #define CHANGHONG_VENDOR_ID			0x2077
 #define CHANGHONG_PRODUCT_CH690			0x7001
 
+/* Inovia */
+#define INOVIA_VENDOR_ID			0x20a6
+#define INOVIA_SEW858				0x1105
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1583,6 +1587,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d03, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) }, /* D-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) }, /* D-Link DWM-156/C1 */
+	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
1.8.3.2

