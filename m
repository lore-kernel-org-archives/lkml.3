Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3KAVpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:45:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3KAVoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:44:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Antonella Pellizzari <anto.pellizzari83@gmail.com>,
        Dan Williams <dcbw@redhat.com>
Subject: [ 32/32] usb: serial: option: blacklist Olivetti Olicard200
Date: Fri,  1 Nov 2013 14:43:43 -0700
Message-Id: <20131101214321.430361179@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101214313.735463599@linuxfoundation.org>
References: <20131101214313.735463599@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enrico Mioso <mrkiko.rs@gmail.com>

commit fd8573f5828873343903215f203f14dc82de397c upstream.

Interface 6 of this device speaks QMI as per tests done by us.
Credits go to Antonella for providing the hardware.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
Signed-off-by: Antonella Pellizzari <anto.pellizzari83@gmail.com>
Tested-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1283,7 +1283,9 @@ static const struct usb_device_id option
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
-	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200),
+		.driver_info = (kernel_ulong_t)&net_intf6_blacklist
+	},
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },


