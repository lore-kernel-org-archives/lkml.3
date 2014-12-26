Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaLZOvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:51:45 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4736 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbaLZOm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:26 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895453"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jay Cliburn <jcliburn@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Chris Snook <chris.snook@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/27] atheros: atlx: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:34 +0100
Message-Id: <1419604558-29743-4-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/net/ethernet/atheros/atlx/atl2.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 84a09e8..482a7ca 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -1436,13 +1436,11 @@ static int atl2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	atl2_check_options(adapter);
 
-	init_timer(&adapter->watchdog_timer);
-	adapter->watchdog_timer.function = atl2_watchdog;
-	adapter->watchdog_timer.data = (unsigned long) adapter;
+	setup_timer(&adapter->watchdog_timer, atl2_watchdog,
+		    (unsigned long)adapter);
 
-	init_timer(&adapter->phy_config_timer);
-	adapter->phy_config_timer.function = atl2_phy_config;
-	adapter->phy_config_timer.data = (unsigned long) adapter;
+	setup_timer(&adapter->phy_config_timer, atl2_phy_config,
+		    (unsigned long)adapter);
 
 	INIT_WORK(&adapter->reset_task, atl2_reset_task);
 	INIT_WORK(&adapter->link_chg_task, atl2_link_chg_task);

