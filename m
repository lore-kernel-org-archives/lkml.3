Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaFWHxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:53:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19384 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaFWHxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:53:49 -0400
X-AuditID: cbfee61a-f79e46d00000134f-1f-53a7dd0b121f
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 07/11] usb: dwc2/gadget: break infinite loop in endpoint
 disable code
Date: Mon, 23 Jun 2014 09:51:26 +0200
Message-id: <1403509890-14103-8-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV3uu8uDDU6sl7WY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVserqXqaCJ6wVnQ8fMjcwPmHpYuTkkBAwkZjz4Q4zhC0m
	ceHeerYuRi4OIYHpjBLX729gh3DamST2LlrFDlLFJqAjseX7BEYQW0RAQGL9i0tgRcwCJxgl
	Ov5fAGrn4BAWCJe4OlEPpIZFQFXi37TtYNt4BVwlOt+cYYLYJidx8thkVhCbU8BNYv3NhWDz
	hYBqFp2exj6BkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODweia1g3Flg8UhRgEO
	RiUeXg235cFCrIllxZW5hxglOJiVRHgbG4BCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcK
	CaQnlqRmp6YWpBbBZJk4OKUaGHtMXFp2O0c+EPpq+O3Np3kiTBNjf3NvL/jEci4hw3LKWbcL
	QdNun9i94fcxJv2ZC/OfNs35lCniwj2xIegSz56bMQtK7+tmNX950vzu4JLDfm4KnFInDbb9
	3Js37cfd1ev+fqjYVKj0sfL49PsnXfM2Ml4qeWYn6/XNk79l4oEvyv+em4n6L96nxFKckWio
	xVxUnAgAkDZ/jysCAAA=
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
index 21d21de..2220882 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1652,6 +1652,7 @@ static void s3c_hsotg_txfifo_flush(struct s3c_hsotg *hsotg, unsigned int idx)
 			dev_err(hsotg->dev,
 				"%s: timeout flushing fifo (GRSTCTL=%08x)\n",
 				__func__, val);
+			break;
 		}
 
 		udelay(1);
-- 
1.9.1

