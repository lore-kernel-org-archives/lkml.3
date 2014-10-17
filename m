Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaJQEoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 00:44:23 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34763 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaJQEoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 00:44:20 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] usb: dwc2: gadget: modify return statement
Date: Fri, 17 Oct 2014 10:14:03 +0530
Message-Id: <1413521043-7587-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modified the function to have a single return statement at the end
instead of multiple return statement in the middle of the function
to improve the readability of the code.

This patch depends on the previous patch of the series.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/usb/dwc2/gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 7f25527..e8a8fc7 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2471,7 +2471,8 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	dir_in = (desc->bEndpointAddress & USB_ENDPOINT_DIR_MASK) ? 1 : 0;
 	if (dir_in != hs_ep->dir_in) {
 		dev_err(hsotg->dev, "%s: direction mismatch!\n", __func__);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto error1;
 	}
 
 	mps = usb_endpoint_maxp(desc);
@@ -2583,6 +2584,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 
 error:
 	spin_unlock_irqrestore(&hsotg->lock, flags);
+error1:
 	return ret;
 }
 
-- 
1.8.1.2

