Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3ILOTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:19:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15691 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3ILOTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:19:37 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-4e-5231cd78ef9f
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Chanho Park <chanho61.park@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/6] usb: s3c-hsotg: do not disconnect gadget when receiving
 ErlySusp intr
Date: Thu, 12 Sep 2013 16:18:49 +0200
Message-id: <1378995532-32142-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
References: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jQd2Ks4ZBBquOSVlsnLGe1eLg/XqL
	y/u1LZoXr2ezONv0ht3i8q45bBaLlrUyW6w9cpfd4sHhnewOnB77565h9+jbsorR4/iN7Uwe
	nzfJBbBEcdmkpOZklqUW6dslcGX8/v2QueADe8WN6ZOZGxjPsHUxcnBICJhI9N9i6mLkBDLF
	JC7cWw8U5uIQEpjOKLH75Sp2CKeLSaL5zktWkCo2AR2JLd8nMILYIgICEutfXAIrYhboZ5LY
	uO8aWJGwQIzE4dfz2EBsFgFViTOvloHFeQVcJeYee8sOsU5e4un9PrAaTgE3ib7d68EuEgKq
	mbg1ZQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwaH1THoH46oGi0OMAhyMSjy8
	iYsNg4RYE8uKK3MPMUpwMCuJ8H6eCBTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2x
	JDU7NbUgtQgmy8TBKdXAyFiu2/CUuaPZx8P6keUj9Qlv2q222DaI8uufnhY/+cH8C18vM+7X
	OCY9Y3GP5vMjvssP+2gYL+66ZM/VveTkA+7pU6s2Vi+xdmC99zHxtGRu7Hyhba/jje6VTBBc
	O/mW/P2vX68yJRpVu59rdLt7Ql5B13Pb591XA33mCc+7qDl1adbth85X05RYijMSDbWYi4oT
	AUJYWjMpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanho Park <chanho61.park@samsung.com>

DWC2 databook indicates if the core sets "ErlySusp" bit, an idle state has been
detected on the USB for 3 ms. This situation can be occurred when waiting
a request from user daemon. So, we should keep the connection between udc and
gadget even though this interrupt is occurred.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index b13a4f9..dd5524c 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2474,8 +2474,6 @@ irq_retry:
 	if (gintsts & GINTSTS_ErlySusp) {
 		dev_dbg(hsotg->dev, "GINTSTS_ErlySusp\n");
 		writel(GINTSTS_ErlySusp, hsotg->regs + GINTSTS);
-
-		s3c_hsotg_disconnect(hsotg);
 	}
 
 	/*
-- 
1.7.9.5

