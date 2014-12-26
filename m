Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaLZOuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:50:09 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4736 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbaLZOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:29 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895471"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 22/27] usb: sl811-hcd: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:52 +0100
Message-Id: <1419604558-29743-22-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/usb/host/sl811-hcd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 25fb1da..cef3140 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1691,9 +1691,7 @@ sl811h_probe(struct platform_device *dev)
 	spin_lock_init(&sl811->lock);
 	INIT_LIST_HEAD(&sl811->async);
 	sl811->board = dev_get_platdata(&dev->dev);
-	init_timer(&sl811->timer);
-	sl811->timer.function = sl811h_timer;
-	sl811->timer.data = (unsigned long) sl811;
+	setup_timer(&sl811->timer, sl811h_timer, (unsigned long)sl811);
 	sl811->addr_reg = addr_reg;
 	sl811->data_reg = data_reg;
 

