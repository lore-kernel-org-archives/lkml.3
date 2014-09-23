Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaIWCjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:39:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:38155 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbaIWCjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:39:10 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brennan Ashton <bashton@brennanashton.com>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 19/45] USB: option: add VIA Telecom CDS7 chipset device id
Date: Tue, 23 Sep 2014 10:31:21 +0800
Message-Id: <1411439507-30391-19-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brennan Ashton <bashton@brennanashton.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit d77302739d900bbca5e901a3b7ac48c907ee6c93 upstream.

This VIA Telecom baseband processor is used is used by by u-blox in both the
FW2770 and FW2760 products and may be used in others as well.

This patch has been tested on both of these modem versions.

Signed-off-by: Brennan Ashton <bashton@brennanashton.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e1e05ba..703ebe7 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -499,6 +499,10 @@ static void option_instat_callback(struct urb *urb);
 #define INOVIA_VENDOR_ID			0x20a6
 #define INOVIA_SEW858				0x1105
 
+/* VIA Telecom */
+#define VIATELECOM_VENDOR_ID			0x15eb
+#define VIATELECOM_PRODUCT_CDS7			0x0001
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1744,6 +1748,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) }, /* D-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) }, /* D-Link DWM-156/C1 */
 	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
+	{ USB_DEVICE(VIATELECOM_VENDOR_ID, VIATELECOM_PRODUCT_CDS7) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
1.7.9.5

