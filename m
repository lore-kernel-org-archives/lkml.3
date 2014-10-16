Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaJPHl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:41:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56714 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaJPHlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:41:25 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] usb: dwc2: gadget: modify return statement
Date: Thu, 16 Oct 2014 13:11:09 +0530
Message-Id: <1413445270-27672-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modified the function to have a single return statement at the end
instead of multiple return statement in the middle of the function
to improve the readability of the code.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/usb/dwc2/gadget.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 7b5856f..af5517f 100644
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
@@ -2561,8 +2562,10 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 			hs_ep->fifo_size = val;
 			break;
 		}
-		if (i == 8)
-			return -ENOMEM;
+		if (i == 8) {
+			ret = -ENOMEM;
+			goto error1;
+		}
 	}
 
 	/* for non control endpoints, set PID to D0 */
@@ -2580,6 +2583,8 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
 
 	spin_unlock_irqrestore(&hsotg->lock, flags);
+
+error1:
 	return ret;
 }
 
-- 
1.8.1.2

