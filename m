Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290AbaGRLkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:40:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42957 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761700AbaGRLka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:40:30 -0400
X-AuditID: cbfee61a-f79e46d00000134f-32-53c907ad19cf
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 12/12] usb: dwc2/gadget: avoid disabling ep0
Date: Fri, 18 Jul 2014 13:39:37 +0200
Message-id: <1405683577-11226-13-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jAd217CeDDc69F7aY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVcfz3BqaC26wVZ06eZ29gvMfSxcjJISFgIvHh/R02CFtM
	4sK99UA2F4eQwCJGibZ5q1ggnHYmidnvdoBVsQnoSGz5PoERxBYREJBY/+ISO0gRs8AJRomO
	/xfAioQF7CVW7Z4FtoJFQFViwcV+JhCbV8BN4tuKj8wQ6+QkTh6bzApicwLF2x79B6rnANrm
	KjHtK/8ERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLD65nUDsaVDRaHGAU4GJV4
	eC1uHg8WYk0sK67MPcQowcGsJMKbfR8oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6
	YklqdmpqQWoRTJaJg1OqgdG9+fusQA4THbvMR4JMjTtLNq7sfsRzbVqazuOGRfGB13y49rRX
	33voEPD90M5jL3Lsmk/eElg25cjD9Xo3Gexk/+1hdeTVX67x9uGygmdvDzzac/D13+mxG7/P
	9FCI8uHa+2tpVPyHx+ELw0NYUrbMsLstvKTD8f41e4dp+0WFb/0IbZ9+JPahEktxRqKhFnNR
	cSIAITBGIisCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Endpoint 0 should not be disabled, so we start loop counter from number 1.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 11f038e..cc31088 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2930,7 +2930,7 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 		return -ENODEV;
 
 	/* all endpoints should be shutdown */
-	for (ep = 0; ep < hsotg->num_of_eps; ep++)
+	for (ep = 1; ep < hsotg->num_of_eps; ep++)
 		s3c_hsotg_ep_disable(&hsotg->eps[ep].ep);
 
 	spin_lock_irqsave(&hsotg->lock, flags);
-- 
1.9.1

