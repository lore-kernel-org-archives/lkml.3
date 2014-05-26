Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaEZVhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:37:15 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:57533 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbaEZVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:37:12 -0400
Message-ID: <1401140229.6068.40.camel@x220>
Subject: [PATCH] usb: gadget: rename CONFIG_USB_GADGET_PXA25X
From: Paul Bolle <pebolle@tiscali.nl>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 23:37:09 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 21:37:10.0081 (UTC) FILETIME=[A6306310:01CF792A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
basically renamed the Kconfig symbol USB_GADGET_PXA25X to USB_PXA25X. It
did not rename the related macros in use at that time. Commit
c0a39151a405 ("ARM: pxa: fix inconsistent CONFIG_USB_PXA27X") did so for
all but one macro. Rename that last macro too now.

Fixes: 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/usb/gadget/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index a925d0cbcd41..a0863a2d2142 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1501,7 +1501,7 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		}
 		break;
 
-#ifndef	CONFIG_USB_GADGET_PXA25X
+#ifndef	CONFIG_USB_PXA25X
 	/* PXA automagically handles this request too */
 	case USB_REQ_GET_CONFIGURATION:
 		if (ctrl->bRequestType != 0x80)
-- 
1.9.0

