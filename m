Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaLZOsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:48:09 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4736 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbaLZOmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:31 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895472"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/27] usb: oxu210hp-hcd: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:53 +0100
Message-Id: <1419604558-29743-23-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/usb/host/oxu210hp-hcd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 036924e..ea0ecbc 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -2598,9 +2598,7 @@ static int oxu_hcd_init(struct usb_hcd *hcd)
 
 	spin_lock_init(&oxu->lock);
 
-	init_timer(&oxu->watchdog);
-	oxu->watchdog.function = oxu_watchdog;
-	oxu->watchdog.data = (unsigned long) oxu;
+	setup_timer(&oxu->watchdog, oxu_watchdog, (unsigned long)oxu);
 
 	/*
 	 * hw default: 1K periodic list heads, one per frame.

