Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaHSI7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:59:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39648 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaHSI7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:59:37 -0400
X-AuditID: cbfee61a-f79e46d00000134f-95-53f311f33273
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 08/12] usb: dwc2/gadget: do not call disconnect
 method in pullup
Date: Tue, 19 Aug 2014 10:54:14 +0200
Message-id: <1408438458-3317-9-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd3Pgp+DDSZ/ErSY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktHj3cymrx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVsX76VvaCeWwVhw5XNTAuYu1i5OSQEDCR6P89gQXCFpO4
	cG89WxcjF4eQwHRGiePvVrNDOO1MEgs+XGAHqWIT0JHY8n0CI4gtIiAvcX3jTRaQImaBQ4wS
	r+4cYwJJCAvESHxZ/gJsBYuAqsTkG2fYQGxeAReJp39/Qa2Tkzh5bDJYDaeAq8TbfbPAFggB
	1WxuPcM2gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg8HomtYNxZYPFIUYBDkYl
	Hl6FLx+DhVgTy4orc4Gu4WBWEuF1fPEpWIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB
	9MSS1OzU1ILUIpgsEwenVANjRlnKVnaBeN8K5XqJl0ZOZ4Sj2961THNdpuiodbW3QMQ34cnn
	HW9UysKLy+p86jY/K9zLF93Cevtcj8w8t9fBJclxDOd5/67Y2qGxYUKvY77mtern1eeXWZrP
	X3swIeD8ywXbmjWvvjkRJtFabvh013G7bcXnt3XHzqlclMqg5ZZ5UUnn5i0lluKMREMt5qLi
	RAC0KvQyKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This leads to potential spinlock recursion in composite framework, other
udc drivers also don't call it directly from pullup method.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index c829c05..1d5e387 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2944,7 +2944,6 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 		s3c_hsotg_phy_enable(hsotg);
 		s3c_hsotg_core_init(hsotg);
 	} else {
-		s3c_hsotg_disconnect(hsotg);
 		s3c_hsotg_phy_disable(hsotg);
 	}
 
-- 
1.9.1

