Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaLZOsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:48:13 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17530 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbaLZOmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:31 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895460"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/27] xhci: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:41 +0100
Message-Id: <1419604558-29743-11-git-send-email-Julia.Lawall@lip6.fr>
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
-t.data = d;
-t.function = f;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/host/xhci.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 01fcbb5..ae6d650 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -473,10 +473,8 @@ static void compliance_mode_recovery(unsigned long arg)
 static void compliance_mode_recovery_timer_init(struct xhci_hcd *xhci)
 {
 	xhci->port_status_u0 = 0;
-	init_timer(&xhci->comp_mode_recovery_timer);
-
-	xhci->comp_mode_recovery_timer.data = (unsigned long) xhci;
-	xhci->comp_mode_recovery_timer.function = compliance_mode_recovery;
+	setup_timer(&xhci->comp_mode_recovery_timer,
+		    compliance_mode_recovery, (unsigned long)xhci);
 	xhci->comp_mode_recovery_timer.expires = jiffies +
 			msecs_to_jiffies(COMP_MODE_RCVRY_MSECS);
 

