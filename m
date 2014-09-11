Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaIKMsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:48:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51612 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <johan@kernel.org>,
        "Brennan Ashton" <bashton@brennanashton.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.530778106@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 070/131] USB: option: add VIA Telecom CDS7 chipset
 device id
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Brennan Ashton <bashton@brennanashton.com>

commit d77302739d900bbca5e901a3b7ac48c907ee6c93 upstream.

This VIA Telecom baseband processor is used is used by by u-blox in both the
FW2770 and FW2760 products and may be used in others as well.

This patch has been tested on both of these modem versions.

Signed-off-by: Brennan Ashton <bashton@brennanashton.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -496,6 +496,10 @@ static void option_instat_callback(struc
 #define INOVIA_VENDOR_ID			0x20a6
 #define INOVIA_SEW858				0x1105
 
+/* VIA Telecom */
+#define VIATELECOM_VENDOR_ID			0x15eb
+#define VIATELECOM_PRODUCT_CDS7			0x0001
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1740,6 +1744,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) }, /* D-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) }, /* D-Link DWM-156/C1 */
 	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
+	{ USB_DEVICE(VIATELECOM_VENDOR_ID, VIATELECOM_PRODUCT_CDS7) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);

