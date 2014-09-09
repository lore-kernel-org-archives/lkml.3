Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbaIIIvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:51:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65014 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbaIIIok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:44:40 -0400
X-AuditID: cbfee61a-f79e46d00000134f-ca-540ebdf65372
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 4/6] usb: dwc2/gadget: do not call disconnect method in pullup
Date: Tue, 09 Sep 2014 10:44:11 +0200
Message-id: <1410252253-13687-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
References: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t9jQd1ve/lCDM7+17Q4eL/eonnxejaL
	y7vmsFksWtbKbLH2yF12i0cPt7JaPDi8k92B3WP/3DXsHn1bVjF6bNn/mdHj+I3tTB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZfzYMJe1YB5bxe5nE1kaGBexdjFyckgImEgcnX0ayhaTuHBvPVsX
	IxeHkMB0RonjL74wQTjtTBK9y7pZQKrYBHQktnyfwAhiiwjIS1zfeJMFpIhZYB+jxPRP29hB
	EsICfhLn+leAFbEIqEpsO/6GGcTmFXCVOPNhAhPEOjmJk8cmg63mFHCTmN/bzwZiCwHVdD5Z
	yziBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCweia1g3Flg8UhRgEORiUe3oxg
	vhAh1sSy4srcQ4wSHMxKIrxXdgOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnN
	Tk0tSC2CyTJxcEo1MC5wcizmLj/sG3bjwr/r0hdr9n1W+pn5ffI1jxP8d5g7/OKTWs68OLTc
	WYsrYqXyTrvtWwp/pievrPPOL9gUFrDuheOV1V8fqblfvj13/sGnpeGV64tfMjeVqrMV9Ly+
	vXrHs9VKh9bzHlQ7qz1to2/KtKlb0ie9vtGQ9SDWOHR79o6Kg+9Dj0opsRRnJBpqMRcVJwIA
	oq4FGCcCAAA=
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
index a451eef..474eae2 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2942,7 +2942,6 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 		s3c_hsotg_phy_enable(hsotg);
 		s3c_hsotg_core_init(hsotg);
 	} else {
-		s3c_hsotg_disconnect(hsotg);
 		s3c_hsotg_phy_disable(hsotg);
 	}
 
-- 
1.9.1

