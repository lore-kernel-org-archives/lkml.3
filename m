Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaLZOrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:47:07 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17532 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbaLZOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:33 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895466"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/27] ath6kl: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:47 +0100
Message-Id: <1419604558-29743-17-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/net/wireless/ath/ath6kl/txrx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 40432fe..3bc3aa7 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1757,9 +1757,7 @@ void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info *aggr_info,
 
 	aggr_conn->aggr_sz = AGGR_SZ_DEFAULT;
 	aggr_conn->dev = vif->ndev;
-	init_timer(&aggr_conn->timer);
-	aggr_conn->timer.function = aggr_timeout;
-	aggr_conn->timer.data = (unsigned long) aggr_conn;
+	setup_timer(&aggr_conn->timer, aggr_timeout, (unsigned long)aggr_conn);
 	aggr_conn->aggr_info = aggr_info;
 
 	aggr_conn->timer_scheduled = false;

