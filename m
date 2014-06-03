Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbaFCVYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:24:04 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37205 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933890AbaFCVYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:24:02 -0400
Date: Wed, 4 Jun 2014 02:53:54 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH 1/2] usb: gadget: mv_u3d_core: Correct clk_disable twice
Message-ID: <7ae844da4d9059d993c9527f59d35c74f47093fc.1401828520.git.himangi774@gmail.com>
References: <cover.1401828519.git.himangi774@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1401828519.git.himangi774@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a call to clk_disable a few lines before the goto
err_alloc_ep_context. The clk goes not get enabled anywhere after that
so this is not required. This patch fixes the bug by removing the deinit
and clk_disable after the goto statement.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 drivers/usb/gadget/mv_u3d_core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/gadget/mv_u3d_core.c b/drivers/usb/gadget/mv_u3d_core.c
index 1624871..c6db4a8 100644
--- a/drivers/usb/gadget/mv_u3d_core.c
+++ b/drivers/usb/gadget/mv_u3d_core.c
@@ -1980,9 +1980,6 @@ err_alloc_trb_pool:
 	dma_free_coherent(&dev->dev, u3d->ep_context_size,
 		u3d->ep_context, u3d->ep_context_dma);
 err_alloc_ep_context:
-	if (pdata->phy_deinit)
-		pdata->phy_deinit(u3d->phy_regs);
-	clk_disable(u3d->clk);
 err_u3d_enable:
 	iounmap(u3d->cap_regs);
 err_map_cap_regs:
-- 
1.9.1

