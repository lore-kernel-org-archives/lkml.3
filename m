Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbaGRLkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:40:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45048 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761658AbaGRLkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:40:16 -0400
X-AuditID: cbfee61a-f79e46d00000134f-fa-53c9079f9d9b
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 08/12] usb: dwc2/gadget: do not call disconnect method in
 pullup
Date: Fri, 18 Jul 2014 13:39:33 +0200
Message-id: <1405683577-11226-9-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jAd357CeDDf6dFLKY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVcebmQZaCeWwVV5qusjQwLmLtYuTkkBAwkZh4YzUzhC0m
	ceHeerYuRi4OIYFFjBIn3m1lAUkICbQzSbROcgGx2QR0JLZ8n8AIYosICEisf3GJHaSBWeAE
	o0TH/wtsIAlhgVCJs5/7wKayCKhKXNs7hR3E5hVwlfjfswxqs5zEyWOTwWxOATeJtkf/gZZx
	AC1zlZj2lX8CI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHB9UxqB+PKBotDjAIc
	jEo8vBY3jwcLsSaWFVfmHmKU4GBWEuHNvg8U4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQ
	SCA9sSQ1OzW1ILUIJsvEwSnVwCgQfXaCRqvwh4PBi3UeKX12P99/+vcfZvbTvrE2eddjH0Yz
	rFiqVbe2fcPmBU891V79T+EVnTVP0mrp624htRs3f6/OLj6yvzV8N0P43r1rD1jcVHqttmj6
	ry/cnzff7dW52DXz7L4LXOuiq56qRR1Ori0LFbS+ZGT5qihum8+3Liv+AxuFclyUWIozEg21
	mIuKEwHMCcAHKgIAAA==
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
index 2220882..def4900 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2945,7 +2945,6 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 		s3c_hsotg_phy_enable(hsotg);
 		s3c_hsotg_core_init(hsotg);
 	} else {
-		s3c_hsotg_disconnect(hsotg);
 		s3c_hsotg_phy_disable(hsotg);
 	}
 
-- 
1.9.1

