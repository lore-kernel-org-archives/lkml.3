Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaLZOuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:50:05 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17526 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858AbaLZOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:29 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895467"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: kernel-janitors@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/27] iwl4965: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:48 +0100
Message-Id: <1419604558-29743-18-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/net/wireless/iwlegacy/4965-mac.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 2748fde..976f65f 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6247,13 +6247,10 @@ il4965_setup_deferred_work(struct il_priv *il)
 
 	INIT_WORK(&il->txpower_work, il4965_bg_txpower_work);
 
-	init_timer(&il->stats_periodic);
-	il->stats_periodic.data = (unsigned long)il;
-	il->stats_periodic.function = il4965_bg_stats_periodic;
+	setup_timer(&il->stats_periodic, il4965_bg_stats_periodic,
+		    (unsigned long)il);
 
-	init_timer(&il->watchdog);
-	il->watchdog.data = (unsigned long)il;
-	il->watchdog.function = il_bg_watchdog;
+	setup_timer(&il->watchdog, il_bg_watchdog, (unsigned long)il);
 
 	tasklet_init(&il->irq_tasklet,
 		     (void (*)(unsigned long))il4965_irq_tasklet,

