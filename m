Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaLZOmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:42:51 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17530 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867AbaLZOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:29 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895473"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/27] usb: r8a66597-hcd: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:54 +0100
Message-Id: <1419604558-29743-24-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/usb/host/r8a66597-hcd.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
index c4bcfae..a048b8e 100644
--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -2483,9 +2483,8 @@ static int r8a66597_probe(struct platform_device *pdev)
 		r8a66597->max_root_hub = 2;
 
 	spin_lock_init(&r8a66597->lock);
-	init_timer(&r8a66597->rh_timer);
-	r8a66597->rh_timer.function = r8a66597_timer;
-	r8a66597->rh_timer.data = (unsigned long)r8a66597;
+	setup_timer(&r8a66597->rh_timer, r8a66597_timer,
+		    (unsigned long)r8a66597);
 	r8a66597->reg = reg;
 
 	/* make sure no interrupts are pending */
@@ -2496,9 +2495,8 @@ static int r8a66597_probe(struct platform_device *pdev)
 
 	for (i = 0; i < R8A66597_MAX_NUM_PIPE; i++) {
 		INIT_LIST_HEAD(&r8a66597->pipe_queue[i]);
-		init_timer(&r8a66597->td_timer[i]);
-		r8a66597->td_timer[i].function = r8a66597_td_timer;
-		r8a66597->td_timer[i].data = (unsigned long)r8a66597;
+		setup_timer(&r8a66597->td_timer[i], r8a66597_td_timer,
+			    (unsigned long)r8a66597);
 		setup_timer(&r8a66597->interval_timer[i],
 				r8a66597_interval_timer,
 				(unsigned long)r8a66597);

