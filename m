Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942AbaJDAik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:38:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbaJCVmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 3.16 148/357] usb: dwc2/gadget: avoid disabling ep0
Date: Fri,  3 Oct 2014 14:28:54 -0700
Message-Id: <20141003212937.922519561@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Baldyga <r.baldyga@samsung.com>

commit 604eac3c0c69e98f2fd0133305f9e777418f1d3b upstream.

Endpoint 0 should not be disabled, so we start loop counter from number 1.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2896,7 +2896,7 @@ static int s3c_hsotg_udc_stop(struct usb
 		return -ENODEV;
 
 	/* all endpoints should be shutdown */
-	for (ep = 0; ep < hsotg->num_of_eps; ep++)
+	for (ep = 1; ep < hsotg->num_of_eps; ep++)
 		s3c_hsotg_ep_disable(&hsotg->eps[ep].ep);
 
 	spin_lock_irqsave(&hsotg->lock, flags);


