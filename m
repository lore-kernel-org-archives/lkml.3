Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaLZOmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:42:39 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17532 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbaLZOm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:28 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895470"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/27] usb: isp1760: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:51 +0100
Message-Id: <1419604558-29743-21-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/usb/host/isp1760-hcd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 395649f..79261d5 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -1359,9 +1359,7 @@ static int isp1760_run(struct usb_hcd *hcd)
 	if (retval)
 		return retval;
 
-	init_timer(&errata2_timer);
-	errata2_timer.function = errata2_function;
-	errata2_timer.data = (unsigned long) hcd;
+	setup_timer(&errata2_timer, errata2_function, (unsigned long)hcd);
 	errata2_timer.expires = jiffies + SLOT_CHECK_PERIOD * HZ / 1000;
 	add_timer(&errata2_timer);
 

