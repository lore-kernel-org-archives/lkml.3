Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576AbaGCJZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:25:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaGCJZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 187/198] usb: gadget: rename CONFIG_USB_GADGET_PXA25X
Date: Thu,  3 Jul 2014 10:20:30 +0100
Message-Id: <1404379241-8590-188-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit d30f2065d6da377cc76771aca5a9850cfca8723b upstream.

Commit 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
basically renamed the Kconfig symbol USB_GADGET_PXA25X to USB_PXA25X. It
did not rename the related macros in use at that time. Commit
c0a39151a405 ("ARM: pxa: fix inconsistent CONFIG_USB_PXA27X") did so for
all but one macro. Rename that last macro too now.

Fixes: 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 570c005062ab..42a30903d4fd 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1509,7 +1509,7 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		}
 		break;
 
-#ifndef	CONFIG_USB_GADGET_PXA25X
+#ifndef	CONFIG_USB_PXA25X
 	/* PXA automagically handles this request too */
 	case USB_REQ_GET_CONFIGURATION:
 		if (ctrl->bRequestType != 0x80)
-- 
1.9.1

