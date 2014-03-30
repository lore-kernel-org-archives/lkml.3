Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaC3X5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:57:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581AbaC3XnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "David McCullough" <david.mccullough@accelecon.com>,
        "Aleksander Morgado" <aleksander@aleksander.es>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Nicolaus Colberg" <nicolaus.colberg@gemalto.com>,
        "Christian Schmiedl" <christian.schmiedl@gemalto.com>,
        "Hans-Christoph Schemmel" <hans-christoph.schemmel@gemalto.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.582154703@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 127/200] USB: serial: option: blacklist interface 4
 for Cinterion PHS8 and PXS8
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1546,7 +1546,8 @@ static const struct usb_device_id option
 	/* Cinterion */
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
-	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHXX) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLXX),
 		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },

