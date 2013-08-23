Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3HWReG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:34:06 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:48462 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab3HWReF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:34:05 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 2/6] staging: ozwpan: Convert hard coded value to Macro
Date: Fri, 23 Aug 2013 18:33:29 +0100
Message-ID: <1377279213-17074-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macro instead of hard coded value for readability.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 83ed64c..89e498b 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -73,6 +73,7 @@ struct oz_urb_link {
 
 /* Holds state information about a USB endpoint.
  */
+#define OZ_EP_BUFFER_SIZE_ISOC  (1024 * 24)
 struct oz_endpoint {
 	struct list_head urb_list;	/* List of oz_urb_link items. */
 	struct list_head link;		/* For isoc ep, links in to isoc
@@ -1261,7 +1262,7 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 			switch (hep->desc.bmAttributes &
 						USB_ENDPOINT_XFERTYPE_MASK) {
 			case USB_ENDPOINT_XFER_ISOC:
-				buffer_size = 24*1024;
+				buffer_size = OZ_EP_BUFFER_SIZE_ISOC;
 				break;
 			case USB_ENDPOINT_XFER_INT:
 				buffer_size = 128;
-- 
1.7.9.5

