Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaF1S07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:26:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbaF1RvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH 3.15 016/139] usb: gadget: rename CONFIG_USB_GADGET_PXA25X
Date: Sat, 28 Jun 2014 10:46:17 -0700
Message-Id: <20140628174606.108265756@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/gadget/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1501,7 +1501,7 @@ gadgetfs_setup (struct usb_gadget *gadge
 		}
 		break;
 
-#ifndef	CONFIG_USB_GADGET_PXA25X
+#ifndef	CONFIG_USB_PXA25X
 	/* PXA automagically handles this request too */
 	case USB_REQ_GET_CONFIGURATION:
 		if (ctrl->bRequestType != 0x80)


