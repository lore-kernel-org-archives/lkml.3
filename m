Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3I0Kb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:31:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11608 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3I0Kb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:31:27 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-62-52455e7d6ac8
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] USB: gadget: s3c-hsotg: fix maxpacket size
Date: Fri, 27 Sep 2013 12:31:09 +0200
Message-id: <1380277869-17855-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t9jQd26ONcggxfWFrNetrNYbJyxntXi
	4P16i+bF69ksLu+aw2axaFkrs8XaI3fZLR4c3snuwOGxf+4ado++LasYPY7f2M7k8XmTXABL
	FJdNSmpOZllqkb5dAlfGtDmf2AvOs1d87ZnG3MC4ka2LkZNDQsBEYm3LWXYIW0ziwr31QHEu
	DiGB6YwST2feZYZw2pkkGts6wKrYBHQktnyfwAhiiwgISKx/cYkdpIhZ4AKjxPsF68CKhAWs
	JXZuPsgKYrMIqEosuP+JBcTmFXCV6Jh9E8jmAFqnIDFnks0ERu4FjAyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYJD5Jn0DsZVDRaHGAU4GJV4eDOyXIKEWBPLiitzDzFKcDArifAu8HQN
	EuJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cAYYhZ/V1lW
	L9G693zpRsfdm+YxMKo5q6x6Inkp7uI0pmNnJL6XV19Z9fDG48L9v532TFOtv+vG6+EmwaOb
	58l5ffFs1uXdurw/GtZU9V9Z0RK6229hhNhH9gdLgqx3pOwpVixzLttlv7SL7X2j4lNFBqt5
	MV6vPBr+/Ve5k6jz5a3MvVkbVI2UWIozEg21mIuKEwFnoc6ADQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes ep maxpacket value from 512 to 1024, becouse it's needed
to handle interupt and isochronous endpoints in high-speed mode. This change
doesn't affect on driver functioning, becouse fifo size (3072) is still enough
for the maximum transaction payload (3*1024 for high-speed high-bandwidtch
endpoints).

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 8a9e2c6..0d1dcbd 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3146,7 +3146,7 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
 
 	hs_ep->parent = hsotg;
 	hs_ep->ep.name = hs_ep->name;
-	hs_ep->ep.maxpacket = epnum ? 512 : EP0_MPS_LIMIT;
+	hs_ep->ep.maxpacket = epnum ? 1024 : EP0_MPS_LIMIT;
 	hs_ep->ep.ops = &s3c_hsotg_ep_ops;
 
 	/*
-- 
1.7.9.5

