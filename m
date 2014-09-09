Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbaIIIos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:44:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65021 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaIIIop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:44:45 -0400
X-AuditID: cbfee61b-f79f86d00000144c-2d-540ebdfb0d10
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 6/6] usb: dwc2/gadget: avoid disabling ep0
Date: Tue, 09 Sep 2014 10:44:13 +0200
Message-id: <1410252253-13687-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
References: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoO6fvXwhBld3MFkcvF9v0bx4PZvF
	5V1z2CwWLWtltnj0cCurxYPDO9kd2Dz2z13D7tG3ZRWjx5b9nxk9jt/YzuTxeZNcAGsUl01K
	ak5mWWqRvl0CV8bF5jlMBbdZK56/PcPSwHiPpYuRk0NCwETiy/4jULaYxIV769m6GLk4hASm
	M0pc6v/KCOG0M0kcvnyWHaSKTUBHYsv3CYwgtoiAvMT1jTdZQIqYBfoZJVbOXgzkcHAIC1hJ
	HN/qAVLDIqAqcfreT1YQm1fAVWJ78z9WiG1yEiePTQazOQXcJOb39rOB2EJANZ1P1jJOYORd
	wMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4lJ5J72Bc1WBxiFGAg1GJhzcjmC9EiDWx
	rLgy9xCjBAezkgjvld1AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KL
	YLJMHJxSDYzewaUlja+/s0dN+hO28JZjH8u7x5rhSvu4jTyUH0jdXX38kXzrNUWWP1cuuO+X
	eavf+bHjcYDpxt57z0UrFgWffdMmXlNbfEn2pmerZd1cjQem3y07Ze/UrBGQTOraqPjMqlxv
	z5LZdnMWL3v0r6EnOn+9QE24u8t3T4bji+7+WJR4qkDS660SS3FGoqEWc1FxIgDWPaARIQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Endpoint 0 should not be disabled, so we start loop counter from number 1.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 43fd3d5..ce6071d 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2895,7 +2895,7 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 		return -ENODEV;
 
 	/* all endpoints should be shutdown */
-	for (ep = 0; ep < hsotg->num_of_eps; ep++)
+	for (ep = 1; ep < hsotg->num_of_eps; ep++)
 		s3c_hsotg_ep_disable(&hsotg->eps[ep].ep);
 
 	spin_lock_irqsave(&hsotg->lock, flags);
-- 
1.9.1

