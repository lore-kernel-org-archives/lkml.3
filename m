Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaHSI7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:59:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55516 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaHSI7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:59:05 -0400
X-AuditID: cbfee61b-f79f86d00000144c-7d-53f311d8320f
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 07/12] usb: dwc2/gadget: break infinite loop in
 endpoint disable code
Date: Tue, 19 Aug 2014 10:54:13 +0200
Message-id: <1408438458-3317-8-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd0bgp+DDVbu07CY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktHj3cymrx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVMe/DefaCJ6wVU1v2szQwPmHpYuTkkBAwkbjfd54RwhaT
	uHBvPVsXIxeHkMB0RolLPXvZIZx2JomNKz+zglSxCehIbPk+AaxDREBe4vrGmywgRcwChxgl
	Xt05xgSSEBZIlLi/8D0ziM0ioCrxYnU32DpeAReJWzOns0Ksk5M4eWwymM0p4Crxdt8sdhBb
	CKhmc+sZtgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfYM+kdjKsaLA4xCnAw
	KvHwKnz5GCzEmlhWXJkLdA0Hs5IIr+OLT8FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcK
	CaQnlqRmp6YWpBbBZJk4OKUaGM0KMi0mLX4RVqtTY6GT0RXDbHDix99N9zgaFYxrrga9vsW3
	U+KSyOwt+9QO9YRUOczMNj3kF2XrdHOaZ7jkvfebI2XMftb8/Lb+VcrLuYuitHuadi7u13Zi
	59h7/JzT+m6vQqmVc0zfpal0OK+LFPpz3vT8VdtX2mmveibHfVzq8XuLdsmpf0osxRmJhlrM
	RcWJAJ3rc0QsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch fixes possible freeze caused by infinite loop in interrupt
context.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 3faa4f3..c829c05 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1651,6 +1651,7 @@ static void s3c_hsotg_txfifo_flush(struct s3c_hsotg *hsotg, unsigned int idx)
 			dev_err(hsotg->dev,
 				"%s: timeout flushing fifo (GRSTCTL=%08x)\n",
 				__func__, val);
+			break;
 		}
 
 		udelay(1);
-- 
1.9.1

