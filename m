Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaF3MnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:43:02 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbaF3MbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:13 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 105/181] usb: gadget: rename CONFIG_USB_GADGET_PXA25X
Date: Mon, 30 Jun 2014 13:52:06 +0200
Message-Id: <aad91de6926f762a55b74029c2bbf3144eae13b7.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d30f2065d6da377cc76771aca5a9850cfca8723b upstream.

Commit 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
basically renamed the Kconfig symbol USB_GADGET_PXA25X to USB_PXA25X. It
did not rename the related macros in use at that time. Commit
c0a39151a405 ("ARM: pxa: fix inconsistent CONFIG_USB_PXA27X") did so for
all but one macro. Rename that last macro too now.

Fixes: 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/gadget/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index b94c049ab0d0..4ac9e9928d67 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1504,7 +1504,7 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		}
 		break;
 
-#ifndef	CONFIG_USB_GADGET_PXA25X
+#ifndef	CONFIG_USB_PXA25X
 	/* PXA automagically handles this request too */
 	case USB_REQ_GET_CONFIGURATION:
 		if (ctrl->bRequestType != 0x80)
-- 
2.0.0

