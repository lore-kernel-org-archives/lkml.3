Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbaCSVAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:00:14 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:46483 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbaCSVAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:00:07 -0400
From: Ben Chan <benchan@chromium.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Suarez <gsuarez@smithmicro.com>
Subject: [PATCH net-next v4 1/2] USB: cdc: add MBIM extended functional descriptor structure
Date: Wed, 19 Mar 2014 14:00:05 -0700
Message-Id: <1395262806-19237-2-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
In-Reply-To: <1395262806-19237-1-git-send-email-benchan@chromium.org>
References: <1395262806-19237-1-git-send-email-benchan@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the MBIM extended functional descriptor structure
defined in "Universal Serial Bus Communications Class Subclass
Specification for Mobile Broadband Interface Model, Revision 1.0,
Errata-1" published by USB-IF.

Signed-off-by: Ben Chan <benchan@chromium.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/usb/cdc.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/usb/cdc.h b/include/uapi/linux/usb/cdc.h
index f35aa0a..b6a9cdd 100644
--- a/include/uapi/linux/usb/cdc.h
+++ b/include/uapi/linux/usb/cdc.h
@@ -56,6 +56,7 @@
 #define USB_CDC_OBEX_TYPE		0x15
 #define USB_CDC_NCM_TYPE		0x1a
 #define USB_CDC_MBIM_TYPE		0x1b
+#define USB_CDC_MBIM_EXTENDED_TYPE	0x1c
 
 /* "Header Functional Descriptor" from CDC spec  5.2.3.1 */
 struct usb_cdc_header_desc {
@@ -205,6 +206,17 @@ struct usb_cdc_mbim_desc {
 	__u8    bmNetworkCapabilities;
 } __attribute__ ((packed));
 
+/* "MBIM Extended Functional Descriptor" from CDC MBIM spec 1.0 errata-1 */
+struct usb_cdc_mbim_extended_desc {
+	__u8	bLength;
+	__u8	bDescriptorType;
+	__u8	bDescriptorSubType;
+
+	__le16	bcdMBIMExtendedVersion;
+	__u8	bMaxOutstandingCommandMessages;
+	__le16	wMTU;
+} __attribute__ ((packed));
+
 /*-------------------------------------------------------------------------*/
 
 /*
-- 
1.9.0.279.gdc9e3eb

