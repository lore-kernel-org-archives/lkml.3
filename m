Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaHSJBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:01:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56082 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaHSJBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:01:46 -0400
X-AuditID: cbfee61a-f79e46d00000134f-ed-53f3126cdf97
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 12/12] usb: dwc2/gadget: avoid disabling ep0
Date: Tue, 19 Aug 2014 10:54:18 +0200
Message-id: <1408438458-3317-13-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQd0coc/BBj9f8FnMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wWjx5uZbV4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DK6H3RyVxwm7ViyopFjA2M91i6GDk5JARMJL4t7WGFsMUk
	LtxbzwZiCwlMZ5TYu6Kui5ELyG5nkjg/6RczSIJNQEdiy/cJjCC2iIC8xPWNN1lAipgFDjFK
	vLpzjAkkISzgJvHj00ugIg4OFgFVic5DtiBhXgFXif7zaxghlslJnDw2GWwxJ1D87b5Z7BCL
	XSQ2t55hm8DIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcHA9k9rBuLLB4hCjAAej
	Eg+vwpePwUKsiWXFlblAx3AwK4nwOr74FCzEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQ
	QHpiSWp2ampBahFMlomDU6qBkefs1dJ0xQs2i/ob08JF9RmaZD5//77t2sz5cUVKvyX/sf0q
	WNHXmtL65Of3C1LWzNd+zV4iNK0lWeTPiYQfpx8u6zkgVfXpfe36Px+2Pj7t0J639aSBU3en
	Sv6T0wqyO5eJiYruPd/Ftygt5sb33fLfJu7Jvm9Yr/DDM33qHr6/evvzVR0bdJVYijMSDbWY
	i4oTAe4Eb9sqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Endpoint 0 should not be disabled, so we start loop counter from number 1.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 148ef3c..3c1dfe1 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2929,7 +2929,7 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 		return -ENODEV;
 
 	/* all endpoints should be shutdown */
-	for (ep = 0; ep < hsotg->num_of_eps; ep++)
+	for (ep = 1; ep < hsotg->num_of_eps; ep++)
 		s3c_hsotg_ep_disable(&hsotg->eps[ep].ep);
 
 	spin_lock_irqsave(&hsotg->lock, flags);
-- 
1.9.1

