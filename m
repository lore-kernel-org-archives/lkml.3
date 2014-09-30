Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaI3VwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:52:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaI3ViN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brennan Ashton <bashton@brennanashton.com>,
        Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 046/103] USB: option: add VIA Telecom CDS7 chipset device id
Date: Tue, 30 Sep 2014 14:30:51 -0700
Message-Id: <1412112708-27356-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brennan Ashton <bashton@brennanashton.com>

commit d77302739d900bbca5e901a3b7ac48c907ee6c93 upstream.

This VIA Telecom baseband processor is used is used by by u-blox in both the
FW2770 and FW2760 products and may be used in others as well.

This patch has been tested on both of these modem versions.

Signed-off-by: Brennan Ashton <bashton@brennanashton.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 2ab1c8c..cbc6fef 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -494,6 +494,10 @@ static void option_instat_callback(struct urb *urb);
 #define INOVIA_VENDOR_ID			0x20a6
 #define INOVIA_SEW858				0x1105
 
+/* VIA Telecom */
+#define VIATELECOM_VENDOR_ID			0x15eb
+#define VIATELECOM_PRODUCT_CDS7			0x0001
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1724,6 +1728,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) }, /* D-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) }, /* D-Link DWM-156/C1 */
 	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
+	{ USB_DEVICE(VIATELECOM_VENDOR_ID, VIATELECOM_PRODUCT_CDS7) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
1.9.1

