Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbaJDAjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:39:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbaJCVmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 3.16 146/357] usb: dwc2/gadget: do not call disconnect method in pullup
Date: Fri,  3 Oct 2014 14:28:52 -0700
Message-Id: <20141003212937.857459284@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit b510df5a36c066da3a188f4ade3404118b63c6de upstream.

This leads to potential spinlock recursion in composite framework, other
udc drivers also don't call it directly from pullup method.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/gadget.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2943,7 +2943,6 @@ static int s3c_hsotg_pullup(struct usb_g
 		s3c_hsotg_phy_enable(hsotg);
 		s3c_hsotg_core_init(hsotg);
 	} else {
-		s3c_hsotg_disconnect(hsotg);
 		s3c_hsotg_phy_disable(hsotg);
 	}
 


