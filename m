Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaLZOrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:47:10 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17530 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbaLZOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:33 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895474"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/27] orinoco_usb: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:55 +0100
Message-Id: <1419604558-29743-25-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a call to init_timer and accompanying intializations of
the timer's data and function fields to a call to setup_timer.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression t,f,d;
@@

-init_timer(&t);
+setup_timer(&t,f,d);
-t.function = f;
-t.data = d;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/wireless/orinoco/orinoco_usb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 9958464..61612a6 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -364,9 +364,7 @@ static struct request_context *ezusb_alloc_ctx(struct ezusb_priv *upriv,
 	atomic_set(&ctx->refcount, 1);
 	init_completion(&ctx->done);
 
-	init_timer(&ctx->timer);
-	ctx->timer.function = ezusb_request_timerfn;
-	ctx->timer.data = (u_long) ctx;
+	setup_timer(&ctx->timer, ezusb_request_timerfn, (u_long)ctx);
 	return ctx;
 }
 

