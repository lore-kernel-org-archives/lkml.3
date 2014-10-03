Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaJCWyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:54:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbaJCWYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brennan Ashton <bashton@brennanashton.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 044/143] USB: option: add VIA Telecom CDS7 chipset device id
Date: Fri,  3 Oct 2014 14:33:59 -0700
Message-Id: <20141003213315.802586523@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brennan Ashton <bashton@brennanashton.com>

commit d77302739d900bbca5e901a3b7ac48c907ee6c93 upstream.

This VIA Telecom baseband processor is used is used by by u-blox in both the
FW2770 and FW2760 products and may be used in others as well.

This patch has been tested on both of these modem versions.

Signed-off-by: Brennan Ashton <bashton@brennanashton.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -494,6 +494,10 @@ static void option_instat_callback(struc
 #define INOVIA_VENDOR_ID			0x20a6
 #define INOVIA_SEW858				0x1105
 
+/* VIA Telecom */
+#define VIATELECOM_VENDOR_ID			0x15eb
+#define VIATELECOM_PRODUCT_CDS7			0x0001
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1724,6 +1728,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) }, /* D-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) }, /* D-Link DWM-156/C1 */
 	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
+	{ USB_DEVICE(VIATELECOM_VENDOR_ID, VIATELECOM_PRODUCT_CDS7) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


