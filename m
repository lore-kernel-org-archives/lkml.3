Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbaCYRi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:38:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55904 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaCYRVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>,
        Christian Schmiedl <christian.schmiedl@gemalto.com>,
        Nicolaus Colberg <nicolaus.colberg@gemalto.com>,
        David McCullough <david.mccullough@accelecon.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 38/81] USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8
Date: Tue, 25 Mar 2014 10:15:51 -0700
Message-Id: <1395767794-5012-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Morgado <aleksander@aleksander.es>

commit 12df84d4a80278a5b1abfec3206795291da52fc9 upstream.

This interface is to be handled by the qmi_wwan driver.

CC: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
CC: Christian Schmiedl <christian.schmiedl@gemalto.com>
CC: Nicolaus Colberg <nicolaus.colberg@gemalto.com>
CC: David McCullough <david.mccullough@accelecon.com>
Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 8a898aa..97aa780 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1526,7 +1526,8 @@ static const struct usb_device_id option_ids[] = {
 	/* Cinterion */
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
-	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHXX) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLXX),
 		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
-- 
1.8.3.2

